defmodule Dogma.Script do
  @moduledoc """
  This module provides the struct that we use to reprisent source files, their
  abstract syntax tree, etc, as well as a few convenient functions for working
  with them.
  """

  alias Dogma.Rules
  alias Dogma.Script

  defstruct path:   nil,
            source: nil,
            lines:  nil,
            ast:    nil,
            valid?: nil,
            errors: []


  @doc """
  Builds a Script struct from the given source code and path
  """
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
  Runs each of the rules Rules.list on the given script
  """
  def run_tests(script, rules \\ nil) do
    (rules || Rules.list)
    |> Enum.reduce( script, fn(rule, x) -> rule.test x end )
  end

  @doc """
  Postwalks the AST, calling the given `fun/2` on each.

  script.errors is used as an accumulator for `fun/2`, the script with the new
  errors is returned.

  `fun/2` should take a node and the errors accumulator as arguments, and
  return {node, errors}
  """
  def walk(script, fun) do
    {_, errors} = Macro.prewalk( script.ast, script.errors, fun )
    %Script{ script | errors: errors }
  end

  @doc """
  Takes a script and an error, and returns the script with the error prepended
  to the error list of the script.
  """
  def register_error(script, error) do
    errors = [error | script.errors]
    %Script{ script | errors: errors }
  end


  defp lines(source) do
    Regex.replace( ~r/\n\z/, source, "" )
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.map(fn {line, i} -> {i + 1, line} end)
  end
end
