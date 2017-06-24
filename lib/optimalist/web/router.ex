defmodule Optimalist.Web.Router do
  use Optimalist.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Optimalist.Web do
    pipe_through :api

    post "/login", Optimalist.Web.UserController, :login
    post "/register", Optimalist.Web.UserController, :register

    resources "/recipes", Optimalist.Web.RecipeController, only: [:index, :create]
    # resources "/ingredients", Optimalist.Web.IngredientController
  end
end
