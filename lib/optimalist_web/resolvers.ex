defmodule OptimalistWeb.Resolvers do
  @moduledoc """
  All of the resolvers for the graphql queries and mutations
  """
  alias Bolt.Sips
  import OptimalistWeb.Util

  def all_recipes(_parent, _args, _resolution) do
    query = """
    MATCH (recipes:Recipe)
    RETURN recipes
    """

    case Sips.query(Sips.conn(), query) do
      {:ok, recipes} ->
        recipes
        |> flatten_nodes("recipes")
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not fetch recipes"}
    end
  end

  def recipe_detail(_parent, %{id: id}, _resolution) do
    query = """
    MATCH (recipe:Recipe)
    WHERE id(recipe) = {id}
    RETURN recipe
    """

    case Sips.query(Sips.conn(), query, %{id: String.to_integer(id)}) do
      {:ok, recipes} ->
        recipes
        |> hd()
        |> flatten_node("recipe")
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not fetch Recipe"}
    end
  end

  def recipe_recipe_ingredients(parent, _args, _resolution) do
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

  def recipe_ingredient_recipe(parent, _args, _resolution) do
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
end
