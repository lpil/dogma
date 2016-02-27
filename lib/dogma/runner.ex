defmodule Dogma.Runner do
  @moduledoc """
  Run each of the given on the given script
  """

  alias Dogma.Rule

  def run_tests(script, rules) when is_map(script) and is_list(rules) do
    rules
    |> Enum.filter(&(&1.enabled))
    |> Enum.map( &Rule.test(&1, script) )
    |> List.flatten
  end
end
