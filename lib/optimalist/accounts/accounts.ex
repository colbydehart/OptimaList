defmodule Optimalist.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false

  alias Optimalist.Accounts.User
  alias Optimalist.DB

  def login(params) do
    with {:ok, user} <- DB.get_user(params["email"]),
         true <- check_pw(user, params["password"]) do
      {:ok, user}
    end
  end

  defp check_pw(user, password), do: Comeonin.Bcrypt.checkpw(password, user.hash)
end
