defmodule Optimalist.Accounts.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Optimalist.DB
  alias Optimalist.Accounts.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}


  def from_token("User:" <> id) do
     {:ok, DB.get_user(id)}
   end
  def from_token(_), do: {:error, "Unknown resource type"}

end
