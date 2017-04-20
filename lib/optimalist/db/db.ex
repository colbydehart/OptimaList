defmodule Optimalist.DB do
  @moduledoc """
  The entry for connecting to the neo4j database.
  """
  import Bolt.Sips
  alias Optimalist.Cypher.User

  # User
  def get_user(id), do: query(conn(), User.get, %{id: id})
  def get_user_by_email(email) do
     query(conn(), User.get_by_email, %{email: email})
   end
  def create_user(params), do: query(conn(), User.create, params)
  def delete_user(id), do: query(conn(), User.delete, %{id: id})
  def update_user(params), do: query(conn(), User.update, params)
  # Recipe
  # Ingredient
end
