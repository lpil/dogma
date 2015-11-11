defmodule Dogma.Rule.MultipleBlankLines do
  @moduledoc """
  A rule that disallows multiple consecutive blank lines.
  """

  @behaviour Dogma.Rule

  alias Dogma.Error

  def test(script), do: test(script, [])

  def test(script, _config = []) do
    test(script, max_lines: 1)
  end

  def test(script, max_lines: max) do
    script.lines |> strip_lines |> check_blank_lines(max)
  end

  defp strip_lines(lines) do
    Enum.map lines, fn {line, text} ->
      {line, String.strip(text)}
    end
  end

  defp check_blank_lines(lines, max, blank_count \\ 0, acc \\ [])

  defp check_blank_lines([], _max, _blank_count, acc) do
    Enum.reverse(acc)
  end

  defp check_blank_lines([{_, ""} | rest], max, blank_count, acc) do
    check_blank_lines(rest, max, blank_count + 1, acc)
  end

  defp check_blank_lines([{line, _} | rest], max, blank_count, acc)
  when blank_count > max do
    check_blank_lines(rest, max, 0, [error(line - 1) | acc])
  end

  defp check_blank_lines([_ | rest], max, _blank_count, acc) do
    check_blank_lines(rest, max, 0, acc)
  end

  defp error(line) do
    %Error{
      rule:    __MODULE__,
      message: "Multiple consecutive blank lines detected.",
      line:    line,
    }
  end

end
