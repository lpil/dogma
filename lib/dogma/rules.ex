defmodule Dogma.Rules do
  @moduledoc """
  Responsible for running of the appropriate rule set on a given set of scripts
  with the appropriate configuration.
  """

  alias Dogma.Formatter
  alias Dogma.Script

  def test(scripts, rule_set) do
    formatter = Formatter.default_formatter
    scripts
    |> Enum.map(&test_script(&1, formatter, rule_set))
  end

  defp test_script(script, formatter, rule_set) do
    errors = script |> Script.run_tests( rule_set )
    script = %Script{ script | errors: errors }
    Formatter.script( script, formatter )
    script
  end
end
