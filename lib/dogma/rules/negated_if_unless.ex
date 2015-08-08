defmodule Dogma.Rules.NegatedIfUnless do
  @moduledoc """
  A rule that disallows the use of an if or unless with a negated predicate
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:if, [line: i], [{:not, _, _}, _]} = node, errors) do
    err = error( :if, i )
    {node, [err | errors]}
  end
  defp check_node({:if, [line: i], [{:!, _, _}, _]} = node, errors) do
    err = error( :if, i )
    {node, [err | errors]}
  end

  defp check_node({:unless, [line: i], [{:not, _, _}, _]} = node, errors) do
    err = error( :unless, i )
    {node, [err | errors]}
  end
  defp check_node({:unless, [line: i], [{:!, _, _}, _]} = node, errors) do
    err = error( :unless, i )
    {node, [err | errors]}
  end

  defp check_node(node, errors) do
    {node, errors}
  end


  defp error(:unless, position) do
    %Error{
      rule: __MODULE__,
      message: "Favour if over a negated unless",
      position: position,
    }
  end
  defp error(:if, position) do
    %Error{
      rule: __MODULE__,
      message: "Favour unless over a negated if",
      position: position,
    }
  end
end
