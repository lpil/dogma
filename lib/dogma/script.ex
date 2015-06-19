defmodule Dogma.Script do
  defstruct path:   nil,
            source: nil,
            lines:  nil,
            ast:    nil,
            valid?: nil,
            errors: []


  def parse(source, path) do
    {valid?, ast} = case Code.string_to_quoted( source, line: 1 ) do
      {:ok, ast} -> {true,  ast}
      error      -> {false, error}
    end
    %Dogma.Script{
      path:   path,
      source: source,
      lines:  lines( source ),
      ast:    ast,
      valid?: valid?,
    }
  end

  def run_tests(script) do
    Enum.reduce(
      Rules.list,
      script,
      fn(rule, x) -> rule.test x end
    )
  end

  defp lines(source) do
    source
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.map(fn {line, i} -> {i + 1, line} end)
  end
end
