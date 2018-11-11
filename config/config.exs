# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :phoenix, :json_library, Jason

# Configures the endpoint
config :optimalist, OptimalistWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QbKz3IAc8Q0h+eaBrGay/VkcA0buuM58j2FR5CnCkWQUX5VkFHWpAE/zqyT30EfC",
  render_errors: [view: OptimalistWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Optimalist.PubSub, adapter: Phoenix.PubSub.PG2]

config :optimalist, salt: System.get_env("SALT")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Bolt Sips
config :bolt_sips, Bolt,
  url: System.get_env("GRAPHENEDB_BOLT_URL"),
  basic_auth: [
    username: System.get_env("GRAPHENEDB_BOLT_USER"),
    password: System.get_env("GRAPHENEDB_BOLT_PASSWORD")
  ],
  pool_size: 5,
  max_overflow: 2,
  ssl: true

# Absinthe
config :absinthe, :schema, GraphQL.Schema

# SMS
config :ex_twilio,
  account_sid: System.get_env("TWILIO_ACCOUNT_SID"),
  auth_token: System.get_env("TWILIO_AUTH_TOKEN"),
  from: System.get_env("TWILIO_FROM")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
