defmodule Dogma.Rule.QuotesInString do
  @moduledoc ~S"""
  A rule that disallows strings containing the double quote character (`"`).

  Use s_sigil or S_sigil instead or string literals in these situation.

      # Bad
      "\""

      # Good
      ~s(")
  """

  @behaviour Dogma.Rule

  alias Dogma.Error

  def test(script, _config = [] \\ []) do
    script.tokens |> check_binary_strings
  end


  defp check_binary_strings(tokens, acc \\ [])

  defp check_binary_strings([], acc) do
    Enum.reverse(acc)
  end

  defp check_binary_strings([{:bin_string, line, [str]} | rest], acc) do
    if str |> invalid? do
      check_binary_strings(rest, [error(line) | acc])
    else
      check_binary_strings(rest, acc)
    end
  end

  defp check_binary_strings([{:"<<", _} | rest], acc) do
    # Don't check inside binary patterns
    inside_binary_literal(rest, acc)
  end

  defp check_binary_strings([_ | rest], acc) do
    check_binary_strings(rest, acc)
  end

  defp inside_binary_literal([{:">>", _} | rest], acc) do
    check_binary_strings(rest, acc)
  end
  defp inside_binary_literal([_ | rest], acc) do
    inside_binary_literal(rest, acc)
  end


  defp invalid?(str) when is_binary(str) do
    probably_not_heredoc = not String.ends_with?(str, "\n")
    probably_not_heredoc and String.contains?(str, ~s("))
  end
  defp invalid?(_), do: false


  defp error(line) do
    %Error{
      rule:    __MODULE__,
      message: ~s(Prefer the S sigil for strings containing `"`),
      line:    Dogma.Script.line(line),
    }
  end
end
