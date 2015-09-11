defmodule Dogma.Rule.DebuggerStatement do
  @moduledoc """
  A rule that disallows calls to `IEx.pry`.

  This is because we don't want debugger breakpoints accidentally being
  committed into our codebase.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script, _config = [] \\ []) do
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
      rule:    __MODULE__,
      message: "Possible forgotten debugger statement detected",
      line:    pos,
    }
  end
end
