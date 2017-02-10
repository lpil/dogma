defmodule Dogma.RuleSet do
  @moduledoc """
  The RuleSet behaviour, used to assert the interface used by our RuleSets
  """

  @doc """
  Returns the rules and configurations for the set.
  """
  @callback rules() :: [%{}]
end
