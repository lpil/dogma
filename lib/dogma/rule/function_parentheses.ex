defmodule Dogma.Rule.FunctionParentheses do
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

  @behaviour Dogma.Rule

  alias Dogma.Error

  def test(script, _config = [] \\ []) do
    script.tokens |> check_function_parens
  end

  defp check_function_parens(tokens, acc \\ [])

  defp check_function_parens([], acc) do
    Enum.reverse(acc)
  end

  defp check_function_parens([{:identifier, _, :def} | rest], acc) do
    inside_function_def(rest, acc)
  end

  defp check_function_parens([{:identifier, _, :defp} | rest], acc) do
    inside_function_def(rest, acc)
  end

  defp check_function_parens([_ | rest], acc) do
    check_function_parens(rest, acc)
  end

  defp inside_function_def([{:paren_identifier, _, _} | rest], acc) do
    inside_function_name(rest, acc)
  end

  defp inside_function_def([{:identifier, _, _} | rest], acc) do
    inside_function_name(rest, acc)
  end

  defp inside_function_def([_ | rest], acc) do
    check_function_parens(rest, acc)
  end

  defp inside_function_name([{:"(", line} | [{:")", _} | rest]], acc) do
    check_function_parens(rest, [error(line) | acc])
  end

  defp inside_function_name([{:identifier, line, _} | rest], acc) do
    check_function_parens(rest, [error(line) | acc])
  end

  defp inside_function_name([_ | rest], acc) do
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
