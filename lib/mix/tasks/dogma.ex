defmodule Mix.Tasks.Dogma do
  use Mix.Task

  @shortdoc "Check Elixir source files for style offences"

  def run(_) do
    Dogma.run
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
