defmodule Dogma.Rules.WindowsLineEndings do
  @moduledoc """
  A rule that disallows any lines terminated with \r\n
  """

  @behaviour Dogma.Rule

  alias Dogma.Error

  @violation_regex ~r/\r\z/

  def test(script) do
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
      position: pos,
    }
  end
end
