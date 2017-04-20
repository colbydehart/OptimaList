# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :optimalist, Optimalist.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LRmgBNndJ6KdHYiqGFItzJigFFfzsE7j79ufKstU/0KjLMxpnLP5ORfrAwyq3uVW",
  render_errors: [view: Optimalist.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Optimalist.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure guardian
config :guardian, Guardian,
  issuer: "OptimaList",
  ttl: {30, :days},
  allowed_drift: 2000,
  secret_key: "foobaryodelwatchrodeo",
  serializer: Optimalist.Accounts.GuardianSerializer

# Neo4j configuration
config :bolt_sips, Bolt,
  url: "neo4j:neo4j@localhost:7687",
  pool_size: 5,
  max_overflow: 2



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
