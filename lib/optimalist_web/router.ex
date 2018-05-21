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
      schema: Optimalist.GraphQL.Schema,
      interface: :simple,
      context: %{pubsub: OptimalistWeb.Endpoint}
    )

    scope "/" do
      pipe_through(:graphql)
      forward("/graphql", Absinthe.Plug, schema: Optimalist.GraphQL.Schema)
    end
  end
end
