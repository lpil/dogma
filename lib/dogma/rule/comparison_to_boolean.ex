defmodule Dogma.Rule.ComparisonToBoolean do
  @moduledoc """
  A rule that disallows comparison to booleans.

  For example, these are considered invalid:

      foo == true
      true != bar
      false === baz

  This is because these expressions evaluate to `true` or `false`, so you
  could get the same result by using either the variable directly, or negating
  the variable.

  Additionally, with a duck typed language such as Elixir, we should be more
  interested in whether something is "truthy" or "falsey" than if they are
  `true` or `false`.
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
