defmodule Dogma.Util.Lines do
  @moduledoc """
  Splits a source string into lines. Amazing!
  """

  def get(source) do
    ~r/\n\z/
    |> Regex.replace(source, "")
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.map(fn {line, i} -> {i + 1, line} end)
  end
end
