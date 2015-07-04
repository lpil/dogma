defmodule Dogma.Rules.VariableName do
  @moduledoc """
  A rule that disallows variable names not in snake_case
  """

  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.walk( &check_node(&1, &2) )
  end


  defp check_node({:=, _, [{name, meta, _}|_]} = node, errors) do
    if name |> to_string |> probably_snake_case? do
      {node, errors}
    else
      {node, [error( meta[:line] ) | errors]}
    end
  end
  defp check_node(node, errors) do
    {node, errors}
  end


  defp probably_snake_case?(name) do
    not String.match?( name, ~r/[A-Z]/ )
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Variable names should be in snake_case",
      position: pos,
    }
  end
end
