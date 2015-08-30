defmodule Dogma.Rules.LiteralInCondition do
  @moduledoc """
  A rule that disallows useless conditional statements that contain a literal
  in place of a variable or predicate function.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  import Dogma.Util.ASTNode, only: [literal?: 1]

  def test(script, _config = [] \\ []) do
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

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Literal value found in conditional",
      line: pos,
    }
  end
end
