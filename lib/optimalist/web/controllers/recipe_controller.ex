defmodule Optimalist.Web.RecipeController do
  @moduledoc """
  Handles logging in and registering users
  """
  use Optimalist.Web, :controller
  alias Optimalist.Recipes.Recipes
  alias Optimalist.Recipes.Recipe
  alias Optimalist.Recipes.Ingredient
  alias Optimalist.DB


  def index(conn, _params) do
    with {:ok, user} <- fetch_user(conn),
         {:ok, recipes} <- Recipes.get_user_recipes(user.id) do
      render(conn, "index.json", recipe: recipes)
    end
  end

  def create(conn, %{"recipe" => recipe}) do
    with {:ok, user} <- fetch_user(conn),
         {:ok, recipe} <- Recipes.create(recipe, user.id) do
      render(conn, "show.json", recipe: recipe)
    end
  end

  def update(conn, %{"recipe" => recipe}) do
    with {:ok, user} <- fetch_user(conn),
         {:ok, recipe} <- Optimalist.Recipes.update(recipe, user) do
      render(conn, "show.json", recipe: recipe)
    end
  end

  defp fetch_user(conn) do
    case Guardian.Plug.current_resource(conn) do
      nil -> {:error, :unauthenticated}
      user -> {:ok, user}
    end
  end
end
