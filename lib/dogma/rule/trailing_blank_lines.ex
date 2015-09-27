defmodule Dogma.Rule.TrailingBlankLines do
  @moduledoc """
  A rule that disallows trailing blank lines as the end of a source file.
  """

  @behaviour Dogma.Rule

  alias Dogma.Error

  @violation_regex ~r/\n\n+\z/

  def test(script, _config = [] \\ []) do
    case script |> violation? do
      false -> []
      pos   -> [error( pos )]
    end
  end

  defp violation?(script) do
    @violation_regex
    |> Regex.run( script.source, return: :index )
    |> case do
      nil      -> false
      [{_, n}] ->
        length( script.lines ) + 2 - n
    end
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Blank lines detected at end of file",
      line: Dogma.Script.line(pos),
    }
  end
end
