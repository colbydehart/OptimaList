defmodule Web.ApiController do
  use Web.Web, :controller

  alias Web.Api

  def index(conn, _params) do
    conn |> json("Hello")
  end
end
