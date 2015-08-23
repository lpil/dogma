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

  Defaults to `Dogma.Rules.Sets.All`
  """
  def selected_set do
    set = Application.get_env :dogma, :rule_set, All
    Module.concat Dogma.Rules.Sets, set
  end


  defp test_script(script, formatter, rule_set) do
    errors = script |> Script.run_tests( rule_set )
    script = %Script{ script | errors: errors }
    Formatter.script( script, formatter )
    script
  end
end
