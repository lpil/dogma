defmodule Dogma.Runner do
  @moduledoc """
  Run each of the given on the given script
  """

  alias Dogma.Rule
  alias Dogma.Script

  def run_tests(%Script{ valid?: false, errors: errors }, _rules) do
    errors
  end

  def run_tests(%Script{} = script, rules) when is_list(rules) do
    rules
    |> Enum.filter(&(&1.enabled))
    |> Enum.map( &Rule.test(&1, script) )
    |> List.flatten
  end
end
