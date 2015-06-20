defmodule Dogma.Rules do

  @doc """
  Returns a list of all modules that define a Dogma rule.

  In order to add a new rule, you must namespace it under Dogma.Rules, and add
  it to the list in the Dogma.Rules.rule_list private function.
  """
  def list do
    Enum.map rule_list, &Module.concat( Dogma.Rules, &1 )
  end

  defp rule_list do
    [
      LineLength,
      TrailingWhitespace,
    ]
  end
end
