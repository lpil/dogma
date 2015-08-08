defmodule Dogma.Rules.DebuggerStatement do
  @moduledoc """
  A rule that disallows calls to IEx.pry, as while useful, we probably don't
  want them committed.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:., m, [{:__aliases__, _, [:IEx]}, :pry]} = node, errors) do
    error = error( m[:line] )
    {node, [error | errors]}
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message: "Possible forgotten debugger statement detected",
      position: pos,
    }
  end
end
