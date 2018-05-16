defmodule OptimalistWeb.Router do
  use OptimalistWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
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

    forward("/graphql", Absinthe.Plug, schema: OptimalistWeb.Schema)
  end
end
