defmodule Web.Router do
  use Web.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :cors_headers
  end


  scope "/v1", Web do
    pipe_through :api
    get "/", ApiController, :index
  end

  defp cors_headers(conn, _opts) do
    conn
    |> put_resp_header("access-control-allow-origin", "*")
  end
end
