defmodule Dogma.Rules.TrailingWhitespace do
  @moduledoc """
  A rule that disallows trailing whitespace at the end of a line.
  """

  @behaviour Dogma.Rule

  alias Dogma.Error

  @regex ~r/\s+\z/

  def test(script, _config = [] \\ []) do
    Enum.reduce( script.processed_lines, [], &check_line(&1, &2) )
  end

  def correction(source, errors) do
    lines = Enum.map(errors, fn err -> err.line end)
    [newline] = Regex.run(~r/\r?\n\z/, source)

    source
    |> String.split(newline)
    |> Enum.with_index
    |> Enum.map(fn {line, i} ->
      if Enum.member?(lines, i + 1) do
        String.replace(line, @regex, "")
      else
        line
      end
    end)
    |> Enum.join(newline)
  end

  defp check_line({i, line}, errors) do
    trimmed_line = String.replace(line, ~r/\r\z/, "")
    case Regex.run( @regex, trimmed_line, return: :index ) do
      nil -> errors
      _   -> [error(i) | errors]
    end
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Trailing whitespace detected",
      line: pos,
    }
  end
end
