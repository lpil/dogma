defmodule Dogma.Rules.ComparisonToBoolean do
  @moduledoc """
  A rule that disallows comparison to booleans.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  for fun <- [:==, :===, :!=, :!==] do
    defp check_node({unquote(fun), meta, [lhs, rhs]}, errors)
    when is_boolean(lhs) or is_boolean(rhs) do
      {node, [error(meta[:line]) | errors]}
    end
  end

  defp check_node(node, errors) do
    {node, errors}
  end

  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Comparison to a boolean is pointless",
      line:    pos
    }
  end
end
