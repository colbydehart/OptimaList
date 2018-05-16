defmodule OptimalistWeb.Mutations do
  alias Bolt.Sips
  import OptimalistWeb.Util

  def create_recipe(_parent, args = %{recipe_ingredients: ris}, _resolution)
      when length(ris) > 0 do
    query = """
    CREATE (recipe:Recipe {name: {name}})
    FOREACH (ri IN {recipe_ingredients} |
        MERGE (i:Ingredient {name: lower(ri.ingredient.name)})
        CREATE (recipe)-[r:Requires {amount: ri.amount, measurement: ri.measurement}]-> (i)
    )
    RETURN DISTINCT recipe
    """

    case Sips.query(Sips.conn(), query, args) do
      {:ok, recipe} ->
        recipe
        |> hd()
        |> flatten_node("recipe")
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not create recipe"}
    end
  end

  def update_recipe(_parent, args, _resolution) do
    query = """
    MERGE (r:Recipe {id: {id}})
    """

    case Sips.query(Sips.conn(), query, args) do
      {:ok, [recipe]} ->
        recipe
        |> flatten_node("recipe")
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not update recipe."}
    end
  end

  def delete_recipe(_parent, %{id: id}, _resolution) do
    query = """
    MATCH (recipe:Recipe)-[rel:Requires]->(:Ingredient)
    WHERE id(recipe) = {id}
    DELETE rel
    DELETE recipe
    RETURN recipe
    """

    case Sips.query(Sips.conn(), query, %{id: String.to_integer(id)}) do
      {:ok, [recipe]} ->
        recipe
        |> flatten_node("recipe")
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not delete recipe"}
    end
  end
end
