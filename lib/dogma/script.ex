defmodule Dogma.Script do
  defstruct path:   nil,
            source: nil,
            lines:  nil,
            quoted: nil,
            errors: []


  def parse(source, path) do
    %Dogma.Script{
      path:   path,
      source: source,
      lines:  lines( source ),
      quoted: Code.string_to_quoted( source ),
    }
  end

  defp lines(source) do
    source
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.map(fn {line, i} -> {i + 1, line} end)
  end
end
