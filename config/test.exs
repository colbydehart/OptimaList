use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :optimalist, OptimalistWeb.Endpoint,
  http: [port: 4001],
  server: false

config :optimalist, salt: "secretsalt"

# Print only warnings and errors during test
config :logger, level: :warn

config :bolt_sips, Bolt,
  url: "test:test@localhost:7687",
  pool_size: 5,
  max_overflow: 2

if File.exists?("test.secret.exs") do
  import_config "test.secret.exs"
end
