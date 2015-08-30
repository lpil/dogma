defmodule Dogma.Rules.LiteralInInterpolation do
  @moduledoc """
  A rule that disallows useless string interpolations that contain a literal value
  instead of a variable or function.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  import Dogma.Util.ASTNode, only: [literal?: 1]

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:::, _, [{{:., _, [Kernel, :to_string]}, meta, [interpolated_token]}, {:binary, _, _}]} = node, errors) do
    if interpolated_token |> literal? do
      {node, [error(meta[:line]) | errors]}
    else
      {node, errors}
    end
  end

  defp check_node(node, errors) do
    {node, errors}
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Literal value found in interpolation",
      line: pos,
    }
  end
end
