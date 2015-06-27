defmodule Dogma.Rules.DebuggerStatement do

  alias Dogma.Script
  alias Dogma.Error

  @moduledoc """
  A rule that disallows calls to IEx.pry, as while useful, we probably don't
  want them committed.
  """

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
