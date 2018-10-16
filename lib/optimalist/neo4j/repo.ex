defmodule Optimalist.Neo4j.Repo do
  alias Bolt.Sips
  import Optimalist.Neo4j.Util
  alias Optimalist.Measurements

  @doc "Fetches all recipes for the given user"
  def all_recipes(user_id) do
    query = """
    MATCH (recipes:Recipe)<-[:Owns]-(u:User)
    WHERE id(u) = $user_id
    RETURN recipes
    """

    case Sips.query(Sips.conn(), query, %{user_id: user_id}) do
      {:ok, recipes} ->
        recipes
        |> flatten_nodes("recipes")
        |> (&{:ok, &1}).()

      error ->
        error
    end
  end

  @doc "Fetches a single recipe"
  def recipe_detail(id, user_id) do
    query = """
    MATCH (recipe:Recipe)<-[:Owns]-(u:User)
    WHERE id(recipe) = $id
    AND id(u) = $user_id
    RETURN recipe
    """

    case Sips.query(Sips.conn(), query, %{id: String.to_integer(id), user_id: user_id}) do
      {:ok, recipes} ->
        recipes
        |> hd()
        |> flatten_node("recipe")
        |> (&{:ok, &1}).()

      error ->
        error
    end
  end

  def create_recipe(params, user_id) do
    query = """
    MATCH (u:User)
    WHERE id(u) = $user_id
    CREATE (recipe:Recipe {name: $params.name, url: $params.url})<-[:Owns]-(u)
    CREATE ()
    FOREACH (ri IN $params.recipe_ingredients |
        MERGE (i:Ingredient {name: lower(ri.ingredient.name)})
        CREATE (recipe)-[r:Requires {amount: ri.amount, measurement: ri.measurement}]-> (i)
    )
    RETURN DISTINCT recipe
    """

    case Sips.query(Sips.conn(), query, %{user_id: user_id, params: params}) do
      {:ok, recipe} ->
        recipe
        |> hd()
        |> flatten_node("recipe")
        |> (&{:ok, &1}).()

      error ->
        error
    end
  end

  def update_recipe(params, id, user_id) do
    query = """
    MATCH (r:Recipe {id: $id})<-[:Owns]-[u:User]
    WHERE id(u) == $user_id
    SET r += {name: $params.name, url: $params.url}
    WITH r
    MATCH (r)-[ris:Requires]
    FOREACH (ri IN $params.recipe_ingredients |
      CASE ri.id
      WHEN nil
      THEN # TODO?
    )
    """

    case Sips.query(Sips.conn(), query, %{id: id, user_id: user_id, params: params}) do
      {:ok, [recipe]} ->
        recipe
        |> flatten_node("recipe")
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not update recipe."}
    end
  end

  @doc "fetches the recipe ingredients for a given recipe id"
  def recipe_recipe_ingredients(recipe_id) do
    query = """
    MATCH (r: Recipe)-[recipe_ingredients:Requires]->(:Ingredient)
    WHERE id(r) = $id
    RETURN recipe_ingredients
    """

    case Sips.query(Sips.conn(), query, %{id: recipe_id}) do
      {:ok, recipe_ingredients} ->
        recipe_ingredients
        |> flatten_nodes("recipe_ingredients")
        |> (&{:ok, &1}).()

      error ->
        error
    end
  end

  @doc "fetches a recipe for a given recipe ingredient id"
  def recipe_ingredient_recipe(recipe_ingredient_id) do
    query = """
    MATCH (ingredient: Ingredient)<-[ri:Requires]-()
    WHERE id(ri) = {id}
    RETURN DISTINCT ingredient
    """

    case Sips.query(Sips.conn(), query, %{id: recipe_ingredient_id}) do
      {:ok, recipe} ->
        recipe
        |> hd()
        |> flatten_node("ingredient")
        |> (&{:ok, &1}).()

      error ->
        error
    end
  end

  @doc """
  returns the optimal grocery list for a given user's list of recipes. the
  length will determine the amount of recipes to collect in the grocery list
  """
  def optimalist(length, user_id) do
    query = """
    MATCH (u:User)-[:Owns]->(r:Recipe)-[i*2]-(rel:Recipe)<-[:Owns]-(w:User)
    MATCH (r)-[*0..2]-(r)
    WHERE id(u) = $user_id
    AND id(w) = $user_id
    WITH r, count(i) AS rel_count
    ORDER BY rel_count DESC
    LIMIT $length
    MATCH (r)-[req:Requires]->(i:Ingredient)
    RETURN DISTINCT r, req, i
    """

    case Sips.query(Sips.conn(), query, %{length: length, user_id: user_id}) do
      {:ok, ingredients} ->
        recipes = flatten_nodes(ingredients, "r")
        recipe_ingredients = flatten_nodes(ingredients, "req")
        ingredients = flatten_nodes(ingredients, "i")

        list =
          ingredients
          |> Enum.zip(recipe_ingredients)
          |> Enum.map(fn {ing, ri} ->
            %{
              amount: ri.amount,
              measurement: ri.measurement,
              name: ing.name
            }
          end)
          |> Enum.group_by(& &1.name)
          |> Enum.map(&merge_same_ingredients/1)
          |> List.flatten()

        {:ok, %{recipes: recipes, list: list}}

      error ->
        error
    end
  end

  def user_by_token(token) do
    query = """
    MERGE (user:User {token: $token})
    RETURN user
    """

    case Sips.query(Sips.conn(), query, %{token: token}) do
      {:ok, user} ->
        user
        |> hd()
        |> flatten_node("user")
        |> (&{:ok, &1}).()

      error ->
        error
    end
  end
end
