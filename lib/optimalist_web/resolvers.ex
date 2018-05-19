defmodule OptimalistWeb.Resolvers do
  @moduledoc """
  All of the resolvers for the graphql queries and mutations
  """
  alias Bolt.Sips
  alias Optimalist.Measurements
  import OptimalistWeb.Util

  def all_recipes(_, _, %{context: %{user: user}}) do
    query = """
    MATCH (recipes:Recipe)<-[:Owns]-(u:User)
    WHERE id(u) = {user_id}
    RETURN recipes
    """

    case Sips.query(Sips.conn(), query, %{user_id: user.id}) do
      {:ok, recipes} ->
        recipes
        |> flatten_nodes("recipes")
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not fetch recipes"}
    end
  end

  def all_recipes(_, _, _), do: {:error, "unauthenticated"}

  def recipe_detail(_parent, %{id: id}, %{context: %{user: user}}) do
    query = """
    MATCH (recipe:Recipe)<-[:Owns]-(u:User)
    WHERE id(recipe) = {id}
    AND id(u) = {user_id}
    RETURN recipe
    """

    case Sips.query(Sips.conn(), query, %{id: String.to_integer(id), user_id: user.id}) do
      {:ok, recipes} ->
        recipes
        |> hd()
        |> flatten_node("recipe")
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not fetch Recipe"}
    end
  end

  def recipe_detail(_, _, _), do: {:error, "unauthenticated"}

  def recipe_recipe_ingredients(parent, _args, %{context: %{user: user}}) do
    query = """
    MATCH (r: Recipe)-[recipe_ingredients:Requires]->(:Ingredient)
    WHERE id(r) = {id}
    RETURN recipe_ingredients
    """

    case Sips.query(Sips.conn(), query, %{id: parent.id}) do
      {:ok, recipe_ingredients} ->
        recipe_ingredients
        |> flatten_nodes("recipe_ingredients")
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not fetch recipe ingredients"}
    end
  end

  def recipe_recipe_ingredients(_, _, _), do: {:error, "unauthenticated"}

  def recipe_ingredient_recipe(parent, _args, %{context: %{user: user}}) do
    query = """
    MATCH (ingredient: Ingredient)<-[ri:Requires]-()
    WHERE id(ri) = {id}
    RETURN DISTINCT ingredient
    """

    case Sips.query(Sips.conn(), query, %{id: parent.id}) do
      {:ok, recipe} ->
        recipe
        |> hd()
        |> flatten_node("ingredient")
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not fetch recipe."}
    end
  end

  def recipe_ingredient_recipe(_, _, _), do: {:error, "unauthenticated"}

  def optimalist(_, %{length: length}, %{context: %{user: user}}) do
    query = """
    MATCH (u:User)-[:Owns]->(r:Recipe)-[i*2]-(rel:Recipe)<-[:Owns]-(w:User)
    MATCH (r)-[*0..2]-(r)
    WHERE id(u) = {user_id}
    AND id(w) = {user_id}
    WITH r, count(i) AS rel_count
    ORDER BY rel_count DESC
    LIMIT 5
    MATCH (r)-[req:Requires]->(i:Ingredient)
    RETURN DISTINCT r, req, i
    """

    case Sips.query(Sips.conn(), query, %{length: length, user_id: user.id}) do
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

      _ ->
        {:error, "Could not create optimalist"}
    end
  end

  def optimalist(_, _, _), do: {:error, "unauthenticated"}

  def merge_same_ingredients({key, ings}), do: Enum.reduce(ings, [], &reduce_ingredients/2)

  def reduce_ingredients(ing, acc) do
    converted = Measurements.convert(ing)

    case(Enum.find(acc, &(Map.get(&1, :measurement) === converted.measurement))) do
      nil ->
        [converted | acc]

      _ ->
        acc
        |> Enum.map(fn i ->
          Map.update(i, :amount, 0, &(&1 + converted.amount))
        end)
    end
  end

  def user_by_token(token) do
    query = """
    MATCH (user:User {token: {token}})
    RETURN user
    """

    case Sips.query(Sips.conn(), query, %{token: token}) do
      {:ok, [%{"user" => user}]} ->
        user
        |> flatten_node()
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not fetch user"}
    end
  end
end
