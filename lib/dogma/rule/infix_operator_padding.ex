use Dogma.RuleBuilder

defrule Dogma.Rule.InfixOperatorPadding,
  [fn_arrow_padding: false, elixir: ">= 1.1.0"] do
  @moduledoc """
  A rule that ensures that all infix operators, except the range operator `..`,
  are surrounded by spaces.

  This rule is only enabled for Elixir v1.1 or greater.

  Good:

      foo = bar

      foo - bar

      foo || bar

      foo |> bar

      foo..bar

  Bad:

      foo=bar

      foo-bar

      foo||bar

      foo|>bar

  By default, no space is required between the `fn` and `->` of an anonymous
  function. A space can be required by setting the `fn_arrow_padding` option to
  `true`.
  """

  @operators [
    :comp_op,
    :comp_op2,
    :dual_op,
    :mult_op,
    :two_op,
    :arrow_op,
    :rel_op,
    :rel_op2,
    :and_op,
    :or_op,
    :match_op,
    :in_match_op,
    :assoc_op,
    :stab_op,
    :pipe_op
  ]

  @subtracters [
    :number,
    :identifier,
    :")",
    :")"
  ]

  @ignore_ops [
    :-,
    :..
  ]

  def test(rule, script) do
    script.tokens
    |> Enum.map(&normalize_token/1)
    |> check_operators(rule)
  end

  defp normalize_token({a, {b, c, d}}), do: {a, b, c, d, nil}
  defp normalize_token({a, {b, c, d}, e}), do: {a, b, c, d, e}
  defp normalize_token({a, {b, c, d}, e, _}), do: {a, b, c, d, e}
  defp normalize_token({a, {b, c, d}, e, _, _}), do: {a, b, c, d, e}
  defp normalize_token({a, {b, c, d}, e, _, _, _}), do: {a, b, c, d, e}

  defp check_operators(tokens, rule, acc \\ [])

  defp check_operators([], _rule, acc), do: Enum.reverse(acc)

  defp check_operators([
    {token, line, _, _, _},
    {:identifier, line, _, _, _},
    {:mult_op, line, _, _, :/}
    | rest], rule, acc)
  when token == :capture_op or token == :. do
    check_operators(rest, rule, acc)
  end

  defp check_operators([
    {token1, line, _, column, _},
    {:dual_op, line, column, _, :-},
    {token3, line, _, _, _}
    | rest], rule, acc)
  when (token1 in @subtracters or token1 == :")")
  and (token3 in @subtracters or token3 == :"(") do
    check_operators(rest, rule, [error(line) | acc])
  end

  defp check_operators([
    {token1, line, _, _, _},
    {:dual_op, line, _, column, :-},
    {token3, line, column, _, _}
    | rest], rule, acc)
  when (token1 in @subtracters or token1 == :")")
  and (token3 in @subtracters or token3 == :"(") do
    check_operators(rest, rule, [error(line) | acc])
  end

  defp check_operators([
    {:fn, line, _, column, _},
    {:stab_op, line, column, _, _}
    | rest], rule, acc) do

    if rule.fn_arrow_padding do
      check_operators(rest, rule, [error(line) | acc])
    else
      check_operators(rest, rule, acc)
    end
  end

  for operator <- @operators do
    defp check_operators([
      {unquote(operator), line, _, column, value},
      {token2, line, column, _, _}
      | rest], rule, acc)
    when not value in @ignore_ops and token2 != :eol do
      check_operators(rest, rule, [error(line) | acc])
    end
  end

  for operator <- @operators do
    defp check_operators([
      {_, line, _, column, _},
      {unquote(operator), line, column, _, value}
      | rest], rule, acc)
    when not value in @ignore_ops do
      check_operators(rest, rule, [error(line) | acc])
    end
  end

  defp check_operators([_ | rest], rule, acc) do
    check_operators(rest, rule, acc)
  end

  defp error(line) do
    %Error{
      rule:    __MODULE__,
      message: "Infix operators should be surrounded by whitespace.",
      line:    line,
    }
  end

end
