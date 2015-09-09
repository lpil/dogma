defmodule Dogma.RuleSet do
  @moduledoc """
  The RuleSet behaviour, used to assert the interface used by our RuleSets
  """

  use Behaviour

  @doc """
  Returns the rules and configurations for the set.
  """
  defcallback rules :: []
end
