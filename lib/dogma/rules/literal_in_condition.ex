defmodule Dogma.Rules.LiteralInCondition do
  @moduledoc """
  A rule that disallows useless conditional statements that contain a literal
  in place of a variable or predicate function.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.walk( &check_node(&1, &2) )
  end


  for fun <- [:if, :unless, :case] do
    defp check_node({unquote(fun), meta, [pred, [do: _]]} = node, errors) do
      if pred |> literal? do
        errors = [error(meta[:line]) | errors]
      end
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
      message:  "Literal value found in conditional",
      position: pos,
    }
  end
end
