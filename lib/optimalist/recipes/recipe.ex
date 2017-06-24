defmodule Optimalist.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Optimalist.Recipes.Ingredient
  alias Optimalist.Accounts.User

  @required ~w(name url user_id)a

  embedded_schema do
    field :name, :string
    field :url, :string
    belongs_to :user, User
    embeds_many :ingredients, Ingredient

    timestamps()
  end

  def changeset(recipe, params = %{}) do
    recipe
    |> cast(params, @required)
    |> cast_embed(:ingredients)
    |> validate_required(@required)
  end
end
