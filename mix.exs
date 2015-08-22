defmodule Dogma.Mixfile do
  use Mix.Project

  @version "0.0.3"

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
        contributors: ["Louis Pilfold"],
        licenses: ["MIT"],
        links: %{ "GitHub" => "https://github.com/lpil/dogma" },
        files: ~w(mix.exs lib README.md LICENCE)
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
      # Test coverage checker
      {:excoveralls, only: ~w(dev test)a},
      # Automatic test runner
      {:mix_test_watch, "~> 0.1.2", only: :dev},

      # Benchmark framework
      {:benchfella, "~> 0.2", only: :dev},

      # Documentation checker
      {:inch_ex, only: ~w(dev test docs)a},
      # Markdown processor
      {:earmark, "~> 0.1", only: :dev},
      # Documentation generator
      {:ex_doc, "~> 0.7", only: :dev},
    ]
  end
end
