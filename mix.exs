defmodule Scroll.MixProject do
  use Mix.Project

  def project do
    [
      app: :scroll,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers() ++ [:phoenix_swagger],
      start_permanent: Mix.env() == :prod,
      dialyzer: dialyzer(),
      aliases: aliases(),
      deps: deps(),
      elixirc_options: [
        warnings_as_errors: true
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Scroll.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.15"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_view, "~> 2.0.2"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:phoenix_swagger, github: "Blatts12/phoenix_swagger"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:jsonapi, "~> 1.4.0"},
      {:pbkdf2_elixir, "~> 2.0"},
      {:bodyguard, "~> 2.4.2"},
      {:corsica, "~> 1.1"},
      {:ex_json_schema, "~> 0.5"},
      {:scrivener_ecto, "~> 2.0"},
      {:paginator, "~> 1.2.0"},
      {:ex_machina, "~> 2.7.0", only: :test},
      {:dialyxir, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.6.3", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.19.0", only: :dev},
      {:sobelow, "~> 0.11.1", only: :dev}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "phx.swagger.generate", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end

  defp dialyzer do
    [
      plt_file:
        {:no_warn, ".dialyzer/elixir-#{System.version()}-erlang-otp-#{System.otp_release()}.plt"}
    ]
  end
end
