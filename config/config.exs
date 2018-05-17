# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :optimalist, OptimalistWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QbKz3IAc8Q0h+eaBrGay/VkcA0buuM58j2FR5CnCkWQUX5VkFHWpAE/zqyT30EfC",
  render_errors: [view: OptimalistWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Optimalist.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Bolt Sips
config :bolt_sips, Bolt,
  url: "neo4j:pass@localhost:7687",
  pool_size: 5,
  max_overflow: 2

# Absinthe
config :absinthe, :schema, OptimalistWeb.Schema

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
