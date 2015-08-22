defmodule Dogma.Rules.PredicateName do
  @moduledoc """
  A rule that disallows tautological predicate names.
  """

  @behaviour Dogma.Rule
  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:def, _, [{name, meta, _}|_]} = node, errors) do
    test_predicate(name, meta, node, errors)
  end
  defp check_node({:defp, _, [{name, meta, _}|_]} = node, errors) do
    test_predicate(name, meta, node, errors)
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  defp test_predicate(line) do
    Regex.run(~r{(is|has)_(\w+)\?}, line)
  end

  defp tautological_predicate?(line) do
    !!(test_predicate(line))
  end

  defp test_predicate({:unquote,_,_} , _meta, node, errors) do
    {node, errors}
  end

  defp test_predicate(function_name, meta, node, errors) do
    name = function_name |> to_string
    if name |> tautological_predicate? do
      {node, [error( meta[:line], test_predicate(name) ) | errors]}
    else
      {node, errors}
    end
  end

  defp error(pos, [name, _prefix, suffix]) do
    %Error{
      rule:     __MODULE__,
      message:  "Favour `#{suffix}?` over `#{name}`",
      position: pos,
    }
  end
end
