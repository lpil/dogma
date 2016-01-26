defmodule Dogma.Rule.TakenName do
  @moduledoc """
  todo: docs

  Favour these: TBD
  Over these: TBD
  """

  @behaviour Dogma.Rule
  alias Dogma.Script
  alias Dogma.Error

  reserved_words = ~w(case if unless use unquote cond import respawn require def)
  @keywords  Enum.reduce(reserved_words, HashSet.new, fn el, acc -> HashSet.put(acc, el) end)

  def test(script, _config = [] \\ []) do
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

  defp test_predicate(name) do
    if HashSet.member?(@keywords, name) do
      name
    else
      nil
    end
  end

  defp test_predicate({:unquote,_,_} , _meta, node, errors) do
    {node, errors}
  end

  defp test_predicate(function_name, meta, node, errors) do
    name = function_name |> to_string |> test_predicate
    if name do
      {node, [error( meta[:line], name ) | errors]}
    else
      {node, errors}
    end
  end

  defp error(pos, name) do
    %Error{
      rule:     __MODULE__,
      message:  "`#{name}` is already taken and overrides standart library",
      line: Dogma.Script.line(pos),
    }
  end
end
