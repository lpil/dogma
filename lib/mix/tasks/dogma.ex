defmodule Mix.Tasks.Dogma do
  use Mix.Task

  @shortdoc "Check Elixir source files for style violations"

  def run(argv) do
    {_options, arguments, _} = OptionParser.parse(argv)
    case arguments do
      [path | _ ]  -> run_dogma(path)
      []           -> run_dogma("")
    end
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
