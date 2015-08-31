defmodule Dogma.Rules.LineLength do
  @moduledoc """
  A rule that disallows lines longer than 80 characters in length.

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
    |> Enum.map(&error/1)
  end


  defp longer_than({_, line}, max) do
    String.length(line) > max
  end

  defp error({line_num, _}) do
    %Error{
      rule:     __MODULE__,
      message:  "Line too long",
      line: line_num,
    }
  end
end
