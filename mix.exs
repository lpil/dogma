defmodule Dogma.Mixfile do
  use Mix.Project

  def project do
    [
      app: :dogma,
      version: "0.0.1",
      elixir: "~> 1.0",
      deps: deps,
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:shouldi, only: :test},
      {:mix_test_watch, "~> 0.1.1"},
    ]
  end
end
