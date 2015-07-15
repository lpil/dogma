defmodule Mix.Tasks.Dogma do
  use Mix.Task

  @shortdoc  "Check Elixir source files for style violations"
  @moduledoc "Check Elixir source files for style violations"

  def run(argv) do
    {options, arguments, _} = OptionParser.parse(argv)
    rule_set = ruleset_from_options(options)

    case arguments do
      [path | _ ]  -> run_dogma(path, rule_set)
      []           -> run_dogma("", rule_set)
    end
  end

  defp run_dogma(path, rule_set) do
    Dogma.run(path, rule_set)
    |> any_errors?
    |> if do
      System.halt(666)
    end
  end

  defp any_errors?(scripts) do
    scripts
    |> Enum.any?( &Enum.any?( &1.errors ) )
  end

  defp ruleset_from_options(rules: module_name) do
    Module.concat([module_name])
  end
  defp ruleset_from_options(_), do: nil

end
