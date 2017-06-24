defmodule Optimalist.Recipes do
  @moduledoc """
  The boundary for the Recipes system.
  """
  alias Optimalist.Recipes.Recipe
  alias Optimalist.DB

  def get_user_recipes(uid), do: DB.get_user_recipes(uid)

  def create(recipe, uid) do
    params = recipe
             |> Map.put("user_id", uid)
    %Recipe{}
    |> Recipe.changeset(params)
    |> DB.create_recipe
  end
end
