defmodule Dogma.Script do
  @moduledoc """
  This module provides the struct that we use to reprisent source files, their
  abstract syntax tree, etc, as well as a few convenient functions for working
  with them.
  """

  alias Dogma.Rules
  alias Dogma.Script
  alias Dogma.Error
  alias Dogma.Util.ScriptStrings

  defstruct path:             nil,
            source:           nil,
            lines:            nil,
            processed_source: nil,
            processed_lines:  nil,
            ast:              nil,
            valid?:           nil,
            errors:           []


  @doc """
  Builds a Script struct from the given source code and path
  """
  def parse(source, path) do
    processed_source = ScriptStrings.blank( source )
    %Script{
      path:             path,
      source:           source,
      lines:            lines( source ),
      processed_source: processed_source,
      processed_lines:  lines( processed_source ),
    } |> add_ast
  end

  defp add_ast(script) do
    case Code.string_to_quoted( script.source, line: 1 ) do
      {:ok, ast} ->
        %Script{ script | valid?: true, ast: ast }
      err ->
        %Script{ script | valid?: false, ast: [], errors: [error( err )] }
    end
  end


  @doc """
  Runs each of the rules Rules.list on the given script
  """
  def run_tests(script, rule_module \\ nil) do
    (rule_module || Rules.Sets.All).list()
    |> Enum.map( &namespace_rule/1 )
    |> Enum.map( &run_test(&1, script) )
    |> List.flatten
  end

  defp namespace_rule({rule, custom_config}) do
    {Module.concat(Dogma.Rules, rule), custom_config}
  end
  defp namespace_rule({rule}) do
    {Module.concat(Dogma.Rules, rule)}
  end

  defp run_test({rule, custom_config}, script) do
    rule.test(script, custom_config)
  end
  defp run_test({rule}, script) do
    rule.test(script)
  end


  @doc """
  Postwalks the AST, calling the given `fun/2` on each.

  script.errors is used as an accumulator for `fun/2`, the script with the new
  errors is returned.

  `fun/2` should take a node and the errors accumulator as arguments, and
  return {node, errors}
  """
  def walk(script, fun) do
    {_, errors} = Macro.prewalk( script.ast, [], fun )
    errors
  end


  defp error({:error, {line, err, _}}) do
    %Error{
      rule:     SyntaxError,
      message:  err,
      position: line - 1,
    }
  end

  defp lines(source) do
    Regex.replace( ~r/\n\z/, source, "" )
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.map(fn {line, i} -> {i + 1, line} end)
  end
end
