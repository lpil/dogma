defmodule Dogma.Rule.Semicolon do
  @moduledoc """
  A rule that disallows semicolons to terminate or separate statements.

  For example, these are considered invalid:

      foo = "bar";
      bar = "baz"; fizz = :buzz

  This is because Elixir does not require semicolons to terminate expressions,
  and breaking up multiple expressions on different lines improves readability.
  """

  @behaviour Dogma.Rule

  alias Dogma.Error

  def test(script, _config \\ []) do
    script.tokens
    |> get_semicolon_lines
    |> Enum.map(&to_error/1)
  end

  defp get_semicolon_lines(tree, acc \\ [])

  defp get_semicolon_lines([], acc) do
    Enum.reverse(acc)
  end

  defp get_semicolon_lines([{:';', line} | rest], acc) do
    get_semicolon_lines(rest, [line | acc])
  end

  defp get_semicolon_lines([{_, _, children} | rest], acc)
  when is_list(children) do
    get_semicolon_lines(children ++ rest, acc)
  end

  defp get_semicolon_lines([{_, children} | rest], acc)
  when is_list(children) do
    get_semicolon_lines(children ++ rest, acc)
  end

  defp get_semicolon_lines([_ | rest], acc) do
    get_semicolon_lines(rest, acc)
  end

  defp to_error(line) do
    %Error{
      rule: __MODULE__,
      message: "Expressions should not be terminated by semicolons.",
      line: Dogma.Script.line(line)
    }
  end
end
