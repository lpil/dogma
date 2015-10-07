defmodule Dogma.Rule.LiteralInCondition do
  @moduledoc """
  A rule that disallows useless conditional statements that contain a literal
  in place of a variable or predicate function.

  This is because a conditional construct with a literal predicate will always
  result in the same behaviour at run time, meaning it can be replaced with
  either the body of the construct, or deleted entirely.

  This is considered invalid:

      if "something" do
        my_function(bar)
      end
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  import Dogma.Util.AST, only: [literal?: 1]

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
      line: Dogma.Script.line(pos),
    }
  end
end
