defmodule OptimalistWeb.Router do
  use OptimalistWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :graphql do
    plug(OptimalistWeb.Context)
  end

  scope "/" do
    pipe_through(:api)

    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: OptimalistWeb.Schema,
      interface: :simple,
      context: %{pubsub: OptimalistWeb.Endpoint}
    )

    scope "/" do
      pipe_through(:graphql)
      forward("/graphql", Absinthe.Plug, schema: OptimalistWeb.Schema)
    end
  end
end
