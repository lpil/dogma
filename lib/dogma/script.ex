defmodule Dogma.Script do
  @moduledoc """
  This module provides the struct that we use to represent source files, their
  abstract syntax tree, etc, as well as a few convenient functions for working
  with them.
  """

  defmodule InvalidScriptError do
    @moduledoc "An exception that can raised when source has invalid syntax."
    defexception [:message]

    def exception(script) do
      %__MODULE__{ message: "Invalid syntax in #{script.path}" }
    end
  end

  alias Dogma.Script
  alias Dogma.Script.Metadata
  alias Dogma.Error
  alias Dogma.Util.ScriptSigils
  alias Dogma.Util.ScriptStrings
  alias Dogma.Util.Lines

  defstruct path:             nil,
            source:           nil,
            lines:            nil,
            processed_source: nil,
            processed_lines:  nil,
            ast:              nil,
            tokens:           [],
            valid?:           false,
            comments:         [],
            ignore_index:     %{},
            errors:           []


  @doc """
  Builds a Script struct from the given source code and path
  """
  def parse(source, path) do
    script = %Script{
      path:             path,
      source:           source,
    } |> add_ast
    if script.valid? do
      script
      |> add_processed_source
      |> add_tokens
      |> add_lines
      |> Metadata.add
    else
      script
    end
  end

  @doc """
  Builds a Script struct from the given source code and path.

  Raises an exception if the source is invalid.
  """
  def parse!(source, path) do
    script = parse( source, path )
    if script.valid? do
      script
    else
      raise InvalidScriptError, script
    end
  end

  defp add_ast(script) do
    case Code.string_to_quoted( script.source, line: 1 ) do
      {:ok, ast} ->
        %Script{ script | valid?: true, ast: ast }
      err ->
        %Script{ script | valid?: false, errors: [error( err )] }
    end
  end

  defp add_tokens(script) do
    if script.valid? do
      tokens = script.source |> tokenize
      %Script{ script | tokens: tokens }
    else
      script
    end
  end

  defp add_processed_source(script) when is_map(script) do
    processed = script.source |> ScriptSigils.strip |> ScriptStrings.strip
    %{ script | processed_source: processed }
  end

  defp add_lines(script) when is_map(script) do
    lines = Lines.get( script.source )
    pro   = Lines.get( script.processed_source )
    %{ script | lines: lines, processed_lines: pro }
  end

  defp tokenize(source) do
    result =
      source
      |> String.to_char_list
      |> :elixir_tokenizer.tokenize( 1, [] )

    case result do
      {:ok, _, tokens}    -> tokens # Elixir 1.0.x
      {:ok, _, _, tokens} -> tokens # Elixir 1.1.x
      {:ok, tokens} -> tokens
    end
  end

  def line({line, _, _}), do: line
  def line(line) when is_integer(line), do: line

  @doc """
  Postwalks the AST, calling the given `fun/2` on each.

  script.errors is used as an accumulator for `fun/2`, the script with the new
  errors is returned.

  `fun/2` should take a ast and the errors accumulator as arguments, and
  return {ast, errors}
  """
  def walk(script, fun) do
    {_, errors} = Macro.prewalk( script.ast, [], fun )
    errors
  end


  defp error({:error, {pos, err, token}}) do
    %Error{
      rule:    SyntaxError,
      message: error_message(err, token),
      line:    line(pos) - 1,
    }
  end

  defp error_message({prefix, suffix}, token) do
    "#{prefix}#{token}#{suffix}"
  end

  defp error_message(err, token) do
    "#{err}#{token}"
  end
end
