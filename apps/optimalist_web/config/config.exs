# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :optimalist_web,
  namespace: Optimalist.Web

# Configures the endpoint
config :optimalist_web, Optimalist.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "D8BqvIgJMdBAfpQFe0xBsoirq0VqntHYP7uerRLRfHGlu5xhtT6w6cHGwB5u8M2g",
  render_errors: [view: Optimalist.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Optimalist.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
