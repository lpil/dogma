defmodule Dogma.Rules.UnlessElse do
  @moduledoc """
  A rule that disallows the use of an `else` block with the `unless` macro.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:unless, [line: i], [_, [do: _, else: _]]} = node, errs) do
    err = error( i )
    {node, [err | errs]}
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Favour if over unless with else",
      position: pos,
    }
  end
end
