defmodule OptimalistWeb.MutationsTest do
  use ExUnit.Case
  alias OptimalistWeb.Mutations

  test "can create a recipe" do
    args = %{
      name: "Noodles",
      recipe_ingredients: [
        %{amount: 1, measurement: "ounce", recipe: %{name: "Spaghetti"}}
      ]
    }

    {:ok, res} = Mutations.create_recipe(nil, args, nil)
    assert res.id
  end
end
