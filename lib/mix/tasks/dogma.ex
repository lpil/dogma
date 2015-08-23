defmodule Mix.Tasks.Dogma do
  use Mix.Task

  @shortdoc  "Check Elixir source files for style violations"
  @moduledoc @shortdoc

  def run(argv) do
    argv |> List.first |> run_dogma
  end

  defp run_dogma(path) do
    Dogma.run(path)
    |> any_errors?
    |> if do
      System.halt(666)
    end
  end

  defp any_errors?(scripts) do
    scripts
    |> Enum.any?( &Enum.any?( &1.errors ) )
  end
end
