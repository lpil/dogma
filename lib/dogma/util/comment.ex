defmodule Dogma.Util.Comment do
  @moduledoc """
  We want to have inline changes of Dogma config using comments, so we need a
  way of getting the comments out of source code.
  """

  defstruct line:    nil,
            content: ""

  @doc """
  Extracts comments from script sources.

  To be run on lines from Dogma.Util.Lines that have been processed already by
  Dogma.Util.ScriptStrings to blank the contents of all string literals.
  """
  def get_all(lines) do
    lines
    |> Enum.reduce( [], &get_comment/2 )
    |> Enum.reverse
  end

  def get_comment( {n, content}, acc ) do
    ~r/#(?<content>.*)\z/
    |> Regex.named_captures( content )
    |> case do
      nil -> acc
      x   -> [%__MODULE__{ line: n, content: x["content"]} | acc]
    end
  end
end
