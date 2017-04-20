defmodule Optimalist.Mixfile do
  use Mix.Project

  def project do
    [app: :optimalist,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Optimalist.Application, []},
     extra_applications: [:logger]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3.0-rc", override: true},
     {:phoenix_pubsub, "~> 1.0"},
     {:gettext, "~> 0.11"},
     {:ecto, "~> 2.1"},
     {:bolt_sips, "~> 0.2"},
     {:credo, "~> 0.7", only: [:dev, :test]},
     {:guardian, "~> 0.14.2"},
     {:comeonin, "~> 3.0"},
     {:cowboy, "~> 1.0"}]
  end
end
