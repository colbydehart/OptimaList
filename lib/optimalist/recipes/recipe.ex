defmodule Optimalist.Recipes.Recipe do
  use Ecto.Schema

  schema "recipes_recipes" do
    field :name, :string

    timestamps()
  end
end
