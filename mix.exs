defmodule Optimalist.Mixfile do
  use Mix.Project

  def project do
    [
      app: :optimalist,
      version: "0.0.1",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Optimalist.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Phoenix
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:cowboy, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:cors_plug, "~> 1.5"},

      # SMS
      {:ex_twilio, "~> 0.6.0"},

      # Scraping
      {:floki, "~> 0.20.0"},
      {:httpoison, "~> 1.0"},

      # GraphQL
      {:absinthe_plug, "~> 1.4.5"},

      # Neo4J
      {:bolt_sips, "~> 0.4"},

      # Dev Stuff
      {:dialyxir, "~> 0.5", only: ~w(dev test)a, runtime: false},
      {:credo, ">= 0.9.1", only: ~w(dev test)a, runtime: false},
      {:phoenix_live_reload, "~> 1.0", only: :dev}
    ]
  end
end
