defmodule Optimalist.Recipes.RecipesTest do
  use ExUnit.Case

  alias Optimalist.DB
  alias Optimalist.Recipes
  alias Optimalist.Accounts

  setup do
    {:ok, _user} = %{changes: %{"email" => "foo@bar.com", "hash" => Comeonin.Bcrypt.hashpwsalt("pass")}}
    |> DB.create_user()
    :ok
  end

  test "logging in a user" do
    {:ok, user} = Accounts.login(%{"email" => "foo@bar.com", "password" => "pass"})
    assert user.email == "foo@bar.com"
  end

  test "registering in a user" do
    {:ok, user} = Accounts.register(%{"email" => "foo@bar.com", "password" => "pass"})
    assert user.email == "foo@bar.com"
  end

  test "creating a recipe" do
    params =
      %{"name" =>  "foobar",
        "url" => "foo.bar",
        "ingredients" => [%{"name" => "corn", "quantity" => 3.00, "measurement" => "cups"},
                          %{"name" => "broth", "quantity" => 1, "measurement" => "quart"},
                          %{"name" => "potato", "quantity" => 4.00, "measurement" => "cups"}]}
    {:ok, recipe} = Recipes.create(params, 1)

    assert length(recipe.ingredients) == 3
    assert recipe.name == "foobar"
  end
end
