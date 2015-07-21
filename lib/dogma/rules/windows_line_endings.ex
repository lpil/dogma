defmodule Dogma.Rules.WindowsLineEndings do
  @moduledoc """
  A rule that disallows any lines terminated with \r\n
  """

  alias Dogma.Script
  alias Dogma.Error

  @violation_regex ~r/\r\z/

  def test(script, _config \\ []) do
    Enum.reduce( script.lines, script, &check_line(&1, &2) )
  end

  defp check_line({i, line}, script) do
    case @violation_regex |> Regex.match?(line) do
      true -> script |> Script.register_error(error(i))
      _    -> script
    end
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Windows line ending detected (\r\n)",
      position: pos,
    }
  end
end
