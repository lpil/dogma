defmodule Dogma.Script do
  defstruct path:   nil,
            source: nil,
            lines:  nil,
            ast:    nil,
            errors: []


  def parse(source, path) do
    {:ok, ast} = Code.string_to_quoted( source, line: 1 )
    %Dogma.Script{
      path:   path,
      source: source,
      lines:  lines( source ),
      ast: ast,
    }
  end

  defp lines(source) do
    source
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.map(fn {line, i} -> {i + 1, line} end)
  end
end
