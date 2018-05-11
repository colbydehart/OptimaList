defmodule OptimalistWeb.Resolvers do
  alias Bolt.Sips

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
    MATCH (ingredient: Ingredient)<-[ri: Requires]-()
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

  @spec flatten_nodes([Sips.Response], binary) :: [map]
  defp flatten_nodes(nodes, key \\ "node"), do: Enum.map(nodes, &flatten_node(&1, key))

  @spec flatten_node(Sips.Response, binary) :: map
  defp flatten_node(node, key \\ "node") do
    data = Map.get(node, key)

    data.properties
    |> Map.put("id", data.id)
    |> atomize_map
  end

  @spec atomize_map(map) :: map
  defp atomize_map(map) do
    map
    |> Enum.map(fn {k, v} ->
      if is_atom(k) do
        {k, v}
      else
        {String.to_existing_atom(k), v}
      end
    end)
    |> Enum.into(%{})
  end
end
