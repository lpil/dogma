defmodule Dogma.Mixfile do
  use Mix.Project

  @version "0.0.11"

  def project do
    [
      app: :dogma,
      version: @version,
      elixir: "~> 1.0",
      deps: deps,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
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
      applications: []
    ]
  end

  defp deps do
    [
      # Test framework
      {:shouldi, only: :test},
      # App config test helper
      {:temporary_env, only: :test},
      # Test coverage checker
      {:excoveralls, only: :test},
      # Automatic test runner
      {:mix_test_watch, only: :dev},

      # Benchmark framework
      {:benchfella, only: :dev},

      # Documentation checker
      {:inch_ex, only: ~w(dev test docs)a},
      # Markdown processor
      {:earmark, only: :dev},
      # Documentation generator
      {:ex_doc, only: :dev},

      # JSON encoder
      {:poison, "~> 1.0"},
    ]
  end
end
