defmodule Dogma.Script do
  alias Dogma.Rules
  alias Dogma.Script

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


  @doc """
  Postwalks the AST, calling the given `fun/2` on each.

  script.errors is used as an accumulator for `fun/2`.

  `fun/2` should take a node and the errors accumulator as arguments, and
  return {node, errors}
  """
  def walk(script, fun) do
    Macro.postwalk( script.ast, script.errors, fun )
  end


  def run_tests(script) do
    Rules.list
    |> Enum.reduce( script, fn(rule, x) -> rule.test x end )
  end

  @doc """
  Takes a script and an error, and returns the script with the error prepended
  to the error list of the script.
  """
  def register_error(script, error) do
    errors = [ error | script.errors ]
    %Script{ script | errors: errors }
  end


  defp lines(source) do
    source
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.map(fn {line, i} -> {i + 1, line} end)
  end
end
