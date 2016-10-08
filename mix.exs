defmodule Dogma.Mixfile do
  use Mix.Project

  @version "0.1.8"

  def project do
    [
      app: :dogma,
      version: @version,
      elixir: "~> 1.0",
      elixirc_paths: elixirc_paths(Mix.env),
      escript: [ main_module: Mix.Tasks.Dogma ],
      deps: deps,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      consolidate_protocols: Mix.env != :test,
      test_coverage: [tool: ExCoveralls],

      name: "Dogma",
      source_url: "https://github.com/lpil/dogma",
      description: "A code style linter for Elixir, powered by shame.",
      package: [
        maintainers: ["Louis Pilfold"],
        licenses: ["MIT"],
        links: %{ "GitHub" => "https://github.com/lpil/dogma" },
      ]
    ]
  end

  def application do
    [
      applications: [:mix]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      # App config test helper
      {:temporary_env, "~> 1.0", only: :test},
      # Test coverage checker
      {:excoveralls, "~> 0.5", only: :test},
      # Automatic test runner
      {:mix_test_watch, "~> 0.2", only: :dev},

      # Benchmark framework
      {:benchfella, "~> 0.3", only: :dev},

      # Documentation checker
      {:inch_ex, "~> 0.5", only: ~w(dev test docs)a},
      # Markdown processor
      {:earmark, "~> 1.0", only: :dev},
      # Documentation generator
      {:ex_doc, "~> 0.14", only: :dev},

      # JSON encoder
      {:poison, ">= 2.0.0"},
    ]
  end
end
