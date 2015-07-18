defmodule Dogma.Rules.LineLength do
  @moduledoc """
  A rule that disallows lines longer than 80 columns in length.
  """

  alias Dogma.Script
  alias Dogma.Error

  def test(script, options \\ []) do
    max = options |> Keyword.get(:max_length, 80)
    script.lines
    |> Enum.filter(fn ({_, line}) -> String.length(line) > max end)
    |> Enum.reduce(script, &add_line_error/2)
  end

  defp add_line_error({i, line}, script) do
    err = error(String.length(line), i)
    Script.register_error(script, err)
  end

  defp error(length, pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Line too long [#{length}]",
      position: pos,
    }
  end
end
