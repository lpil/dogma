use Dogma.RuleBuilder

defrule Dogma.Rule.TrailingWhitespace do
  @moduledoc """
  A rule that disallows trailing whitespace at the end of a line.
  """

  @regex ~r/\s+\z/

  def test(_rule, script) do
    Enum.reduce( script.processed_lines, [], &check_line(&1, &2) )
  end

  defp check_line({i, line}, errors) do
    trimmed_line = normalize_line_endings(line)
    case Regex.run( @regex, trimmed_line, return: :index ) do
      nil -> errors
      _   -> [error(i) | errors]
    end
  end

  defp normalize_line_endings(line) do
    String.replace(line, ~r/\r\z/, "")
  end

  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Trailing whitespace detected",
      line:    Dogma.Script.line(pos),
    }
  end
end
