defmodule Optimalist.Web.Router do
  use Optimalist.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Optimalist.Web do
    pipe_through :api
  end
end
