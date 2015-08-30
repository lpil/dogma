defmodule Dogma.Rules.LiteralInInterpolation do
  @moduledoc """
  A rule that disallows useless string interpolations that contain a literal value
  instead of a variable or function.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

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


  defp literal?(x) when is_atom       x do true end
  defp literal?(x) when is_binary     x do true end
  defp literal?(x) when is_bitstring  x do true end
  defp literal?(x) when is_boolean    x do true end
  defp literal?(x) when is_function   x do true end
  defp literal?(x) when is_list       x do true end
  defp literal?(x) when is_map        x do true end
  defp literal?(x) when is_pid        x do true end
  defp literal?(x) when is_port       x do true end
  defp literal?(x) when is_number     x do true end
  defp literal?(x) when is_reference  x do true end
  defp literal?({:{}, _, _}) do
    true
  end
  defp literal?(_) do
    false
  end


  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Literal value found in interpolation",
      line: pos,
    }
  end
end
