defmodule Dogma.Rule.WindowsLineEndings do
  @moduledoc ~S"""
  A rule that disallows any lines terminated with `\r\n`, the line terminator
  commonly used on the Windows operating system.

  The preferred line terminator is is the Unix style `\n`.

  If you are a Windows user you should be able to configure your editor to
  write files with Unix style `\n` line terminators.
  """

  @behaviour Dogma.Rule

  alias Dogma.Error

  @violation_regex ~r/\r\z/

  def test(script, _config = [] \\ []) do
    Enum.reduce( script.lines, [], &check_line(&1, &2) )
  end

  defp check_line({i, line}, acc) do
    case @violation_regex |> Regex.match?(line) do
      true -> [error(i) | acc]
      _    -> acc
    end
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Windows line ending detected (\r\n)",
      line: Dogma.Script.line(pos),
    }
  end
end
