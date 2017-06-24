defmodule Optimalist.Recipes.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Optimalist.Recipes.Recipe

  @allowed ~w(name quantity measurement)a

  embedded_schema do
    field :name, :string
    field :quantity, :float
    field :measurement, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, @allowed)
  end
end
