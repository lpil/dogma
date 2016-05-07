use Dogma.RuleBuilder

defrule Dogma.Rule.FunctionParentheses do
  @moduledoc """
  A rule that ensures function declarations use parentheses if and only if
  they have arguments.

  For example, this rule considers these function declarations valid:

      def foo do
        :bar
      end

      defp baz(a, b) do
        :fudd
      end

  But it considers these invalid:

      def foo() do
        :bar
      end

      defp baz a, b do
        :fudd
      end
  """

  def test(_rule, script) do
    check_function_parens(script.tokens)
  end

  defp check_function_parens(tokens, acc \\ [])

  defp check_function_parens([], acc) do
    Enum.reverse(acc)
  end

  defp check_function_parens([
    {:identifier, line, name},
    {:identifier, _, _},
    {:identifier, _, _}
    | rest], acc)
  when name == :def or name == :defp do
    check_function_parens(rest, [error(line) | acc])
  end

  defp check_function_parens([
    {:identifier, line, name},
    {:paren_identifier, _, _},
    {:"(", _},
    {:")", _}
    | rest], acc)
  when name == :def or name == :defp do
    check_function_parens(rest, [error(line) | acc])
  end

  defp check_function_parens([_ | rest], acc) do
    check_function_parens(rest, acc)
  end

  defp error(line) do
    %Error{
      rule:    __MODULE__,
      message: "Functions declarations should have parentheses if and " <>
        "only if they have arguments",
      line:    Dogma.Script.line(line),
    }
  end
end
