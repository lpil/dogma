defmodule Dogma.Rules do
  @moduledoc """
  Responsible for running of the appropriate rule set on a given set of scripts
  with the appropriate configuration.
  """

  alias Dogma.Script

  @default_rule_set Dogma.RuleSet.All

  @doc """
  Runs the rules in the current rule set on the given scripts.
  """
  def test(scripts, rules, dispatcher) do
    scripts
    |> Enum.map(&Task.async(fn -> test_script(&1, dispatcher, rules) end))
    |> Enum.map(&Task.await/1)
  end

  defp test_script(script, dispatcher, rules) do
    errors = script |> Script.run_tests( rules )
    script = %Script{ script | errors: errors }
    GenEvent.sync_notify(dispatcher, {:script_tested, script})
    script
  end
end
