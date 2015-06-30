defmodule Dogma.Rules.TrailingWhitespace do
  @moduledoc """
  A rule that disallows trailing whitespace at the end of a line.
  """

  alias Dogma.Script
  alias Dogma.Error

  @regex ~r/\s+\z/

  def test(script) do
    Enum.reduce( script.lines, script, &check_line(&1, &2) )
  end

  defp check_line({i, line}, script) do
    trimmed_line = String.replace(line, ~r/\r\z/, "")
    case Regex.run( @regex, trimmed_line, return: :index ) do
      [{x, _}] -> Script.register_error( script, error(x, i) )
      nil      -> script
    end
  end

  defp error(col, pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Trailing whitespace detected [#{col}]",
      position: pos,
    }
  end
end
