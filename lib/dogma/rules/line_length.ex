defmodule Dogma.Rules.LineLength do
  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    Enum.reduce( script.lines, script, &check_line(&1, &2) )
  end

  def too_long?(num) do
    num > 79
  end

  defp check_line({i, line}, script) do
    len = String.length( line )
    if too_long?( len ) do
      err = error(len, i)
      Script.register_error( script, err )
    else
      script
    end
  end

  defp error(length, pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Line too long [#{length}]",
      position: pos,
    }
  end
end
