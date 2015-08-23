defmodule Dogma.Rules do
  @moduledoc """
  Responsible for running of the appropriate rule set on a given set of scripts
  with the appropriate configuration.
  """

  alias Dogma.Formatter
  alias Dogma.Script


  @doc """
  Runs the rules in the current rule set on the given scripts.
  """
  def test(scripts) do
    formatter = Formatter.default_formatter
    scripts
    |> Enum.map(&test_script(&1, formatter, selected_set))
  end


  @doc """
  Returns currently selected rule set, as specified in the mix config.

  Defaults to `Dogma.RuleSet.All`
  """
  def selected_set do
    set = Application.get_env :dogma, :rule_set, All
    Module.concat Dogma.RuleSet, set
  end


  defp test_script(script, formatter, rule_set) do
    rules  = rule_set.list
    errors = script |> Script.run_tests( rules )
    script = %Script{ script | errors: errors }
    Formatter.script( script, formatter )
    script
  end
end
