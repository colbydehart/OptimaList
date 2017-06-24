defmodule Optimalist.DB do
  @moduledoc """
  The entry for connecting to the neo4j database.
  """
  import Bolt.Sips
  alias Ecto.Changeset
  alias Optimalist.Cypher.User
  alias Optimalist.Cypher.Recipe
  alias Optimalist.Accounts


  # User
  def get_user(id), do: do_query(User.get, %{id: id})
  def get_user_by_email(email) do
    do_query(User.get_by_email, %{email: email})
  end
  def create_user(changeset = %{valid: false}), do: {:error, changeset}
  def create_user(changeset), do: do_query(User.create, %{props: changeset.changes})
  def update_user(changeset = %{valid: false}), do: {:error, changeset}
  def update_user(changeset), do: do_query(User.update, %{props: changeset.changes})
  def delete_user(id), do: do_query(User.delete, %{id: id})

  # Recipe
  def get_user_recipes(id) do
    with {:ok, response} <- query(conn(), Recipe.get_user_recipes, %{id: id}) do
      {:ok, merge_recipe(response)}
    end
  end
  def get_recipe(id) do
    with {:ok, response} <- query(conn(), Recipe.get_recipe, %{id: id}) do
      {:ok, merge_recipe(response)}
    end
  end

  def create_recipe(changeset = %{valid: false}), do: {:error, changeset}
  def create_recipe(changeset) do
    with props <- Changeset.apply_changes(changeset),
         {:ok, response} <- query(conn(), Recipe.create, %{props: props}) do
         merge_recipe(response)
     end
  end
  # def update_recipe(changeset = %{valid: false}), do: {:error, changeset}
  # def update_recipe(changeset), do: do_query(Recipe.update, %{props: changeset.changes})
  # def delete_recipe(id), do: do_query(Recipe.delete, %{id: id})
  # Optimalist
  # def create_list(params), do: do_query(Recipe.create_list, params)

  def do_query(cypher, params) do
    with {:ok, [%{"n" => node} | _rest]} <- query(conn(), cypher, params) do
      {:ok, squash_node(node)}
    end
  end

  def merge_recipe(response) do
    recipe = Enum.reduce(response, %{}, &reduce_recipe/2)
    {:ok, recipe}
  end

  def reduce_recipe(r, acc) do
    ingredient =
      r["ingredient"]
      |> squash_node
      |> Map.drop([:id])
    requires =
      r["requires"]
      |> squash_node
      |> Map.merge(ingredient)


    acc
    |> Map.update(:ingredients, [requires], &([requires | &1]))
    |> Map.merge(squash_node(r["recipe"]))
  end

  # Helper functions
  #
  @doc """
  squashes a neo4j node into a map with its properties as keys
  """
  def squash_node(node) do
    node.properties
    |> Map.put("id", node.id)
    |> Enum.map(&atomize/1)
    |> Enum.into(%{})
  end

  def atomize({k,v}) when is_binary(k), do: {String.to_existing_atom(k), v}
  def atomize({k,v}), do: {k, v}
end
