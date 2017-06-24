defmodule Optimalist.Web.UserController do
  @moduledoc """
  Handles logging in and registering users
  """
  use Optimalist.Web, :controller
  alias Optimalist.Accounts.User
  alias Optimalist.DB

  def login(conn, params) do
    with {:ok, user} <- Optimalist.Accounts.login(params) do
      new_conn = Guardian.Plug.api_sign_in(conn, user)
      jwt = Guardian.Plug.current_token(new_conn)

      new_conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> render("login.json", user: user, jwt: jwt)
    end
  end

  def register(conn, params) do
    with changeset <- User.registration_changeset(%User{}, params),
         {:ok, user} = DB.create_user(changeset) do
      render(conn, "user.json", user: user)
    end
  end
end
