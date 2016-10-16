use Dogma.RuleBuilder

defrule Dogma.Rule.ComparisonToBoolean do
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

  def test(_rule, script) do
    script |> Script.walk( &check_ast(&1, &2) )
  end

  for fun <- [:==, :===, :!=, :!==] do
    defp check_ast({unquote(fun), meta, [lhs, rhs]} = ast, errors)
    when is_boolean(lhs) or is_boolean(rhs) do
      {ast, [error(meta[:line]) | errors]}
    end
  end

  defp check_ast(ast, errors) do
    {ast, errors}
  end

  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Comparison to a boolean is pointless",
      line:    pos
    }
  end
end
