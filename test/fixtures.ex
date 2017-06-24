defmodule Optimalist.Fixtures do
  use Bolt.Sips
  alias Faker.Internet
  alias Faker.Lorem
  alias Optimalist.DB
  alias Optimalist.Recipes.Recipe
  alias Optimalist.Accounts.User

  def fixture(:user) do
    params = %{email: Internet.email, name: Lorem.word}
    %User{}
    |> User.changeset(params)
    |> DB.create_user
    |> elem(1)
  end

  def fixture(:recipe, assoc // []) do
    ingredients = assoc[:ingredients] || [fixture(:ingredient)]
    user = assoc[:user] || fixture(:user)
    params =
      %{name: Lorem.word,
        url: Internet.url,
        user_id: user.id,
        ingredients: ingredients}

    %Recipe{}
    |> Recipe.changeset(params)
    |> DB.create_recipe
    |> elem(1)
  end

  def fixture(:ingredient) do
    %{name: Lorem.word,
      amount: 1,
      measurement: "cup"}
  end
end
