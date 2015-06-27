defmodule Dogma.Rules.TrailingBlankLines do
  @moduledoc """
  A rule that disallows trailing blank lines as the end of a source file.
  """

  alias Dogma.Script
  alias Dogma.Error

  @violation_regex ~r/\n\n+\z/

  def test(script) do
    case script |> violation? do
      false -> script
      pos   -> script |> add_error( pos )
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

  defp add_error(script, pos) do
    error = %Error{
      rule:     __MODULE__,
      message:  "Blank lines detected at end of file",
      position: pos,
    }
    script |> Script.register_error( error )
  end
end
