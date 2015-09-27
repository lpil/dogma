defmodule Dogma.Rule.LineLength do
  @moduledoc """
  A rule that disallows lines longer than X characters in length (defaults to
  80).

  This rule can be configured with the `max_length` option, which allows you to
  specify your own line max character count.
  """

  @behaviour Dogma.Rule

  alias Dogma.Error

  def test(script), do: test(script, [])

  def test(script, _config = []) do
    test(script, max_length: 80)
  end

  def test(script, max_length: max) do
    script.lines
    |> Enum.filter(&longer_than(&1, max))
    |> Enum.map(&error(&1, max))
  end


  defp longer_than({_, line}, max) do
    String.length(line) > max
  end

  defp error({pos, line}, max) do
    len = String.length(line)
    %Error{
      rule:     __MODULE__,
      message:  "Line length should not exceed #{max} chars (was #{len}).",
      line: Dogma.Script.line(pos),
    }
  end
end
