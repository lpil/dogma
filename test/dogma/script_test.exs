defmodule Dogma.ScriptTest do
  use ExUnit.Case, async: true

  alias Dogma.Error
  alias Dogma.Script
  alias Dogma.Script.InvalidScriptError
  alias Dogma.Util.Comment

  describe "parse/2 with a valid script" do
    setup _ do
      source = """
      defmodule Foo do
        def greet do
          "Hello world!" # Comment
        end # Another
      end
      """
      %{
        source: source,
        script: Script.parse( source, "lib/foo.ex" ),
      }
    end

    test "assign path", context do
      assert "lib/foo.ex" == context.script.path
    end

    test "assign source", context do
      assert context.source == context.script.source
    end

    test "assign processed source", context do
      processed_source = """
      defmodule Foo do
        def greet do
          "" # Comment
        end # Another
      end
      """
      assert processed_source == context.script.processed_source
    end

    test "assign an empty list of errors", context do
      assert [] == context.script.errors
    end

    test "assigns lines", context do
      lines = [
        {1,  ~s(defmodule Foo do)},
        {2,  ~s(  def greet do)},
        {3,  ~s(    "Hello world!" # Comment)},
        {4,  ~s(  end # Another)},
        {5,  ~s(end)},
      ]
      assert lines == context.script.lines
    end

    test "assigns processed lines", context do
      lines = [
        {1,  ~s(defmodule Foo do)},
        {2,  ~s(  def greet do)},
        {3,  ~s(    "" # Comment)},
        {4,  ~s(  end # Another)},
        {5,  ~s(end)},
      ]
      assert lines == context.script.processed_lines
    end

    test "assign valid? as true", context do
      assert context.script.valid?
    end

    test "assigns the quoted abstract syntax tree", context do
      {:ok, ast} = Code.string_to_quoted( context.source )
      assert ast == context.script.ast
    end

    test "include line numbers in the quoted ast" do
      script = Script.parse( "1 + 1", "" )
      assert {:+, [line: 1], [1, 1]} == script.ast
    end

    test "assigns the tokenized source", context do
      assert [
        {:identifier, _, :defmodule}, {:aliases, _, [:Foo]},
        {:do, _}, {:eol, _}, {:identifier, _, :def},
        {:do_identifier, _, :greet}, {:do, _}, {:eol, _},
        {:bin_string, _, ["Hello world!"]}, {:eol, _}, {:end, _},
        {:eol, _}, {:end, _}, {:eol, _},
      ] = context.script.tokens
    end

    test "assign comments", context do
      assert context.script.comments == [
        %Comment{ content: " Comment", line: 3 },
        %Comment{ content: " Another", line: 4 },
      ]
    end
  end

  describe "parse/2 with an invalid script" do
    setup _ do
      source = ~s"""
      <>>>>>>><><>><><>>>>>>>>>>>>>><<><
      """
      %{
        script: Script.parse( source, "" ),
      }
    end

    test "assign valid? as false", context do
      refute context.script.valid?
    end

    test "assign nil in place of AST", context do
      assert nil == context.script.ast
    end

    test "assign nil in place of tokens", context do
      assert nil == context.script.ast
    end

    test "assign nil in place of lines", context do
      assert nil == context.script.lines
    end

    test "assign nil in place of processed_source", context do
      assert nil == context.script.processed_source
    end

    test "assign nil in place of processed_lines", context do
      assert nil == context.script.processed_lines
    end

    test "assign a syntax error", context do
      error = %Error{
        rule: SyntaxError,
        message: ~s[missing terminator: >> (for "<<" starting at line 1)],
        line: 1,
      }
      assert [error] == context.script.errors
    end
  end


  describe "parse/2 with an invalid script with a tuple error message" do
    setup _ do
      source = ~s"""
      defmodule Module do
        <>>>>>>><><>><><>>>>>>>>>>>>>><<><
      end
      """
      %{
        script: Script.parse( source, "" ),
      }
    end

    test "assign a syntax error with the flattened message", context do
      [%Error{ message: message }] = context.script.errors

      assert(
        message ==
          ~s(unexpected token: "end". ) <>
          ~s("<<" starting at line 2 is missing terminator ">>")
          or
        # in Elixir 1.0 syntax errors weren't returned correctly
        # https://github.com/elixir-lang/elixir/issues/2993
        message ==
          ~s("<<" starting at line 2 is missing terminator ">>". ) <>
          ~s(Unexpected token: end)
      )
    end
  end


  describe "parse/2 with a script with trailing blank lines" do
    setup _ do
      source = """
      1 + 2


      """
      %{
        source: source,
        script: Script.parse( source, "lib/foo.ex" ),
      }
    end

    test "preserve the extra blank lines", context do
      lines = [
        {1, "1 + 2"},
        {2, ""},
        {3, ""},
      ]
      assert lines == context.script.lines
    end

    test "register ignored lines" do
      script = """
      defmodule Foo_Bar do # dogma:ignore Something SomethingElse
        @foo 1 # dogma:ignore SomethingElse
      end
      """ |> Script.parse("")
      expected = %{
        Something     => Enum.into([1], HashSet.new),
        SomethingElse => Enum.into([1, 2], HashSet.new),
      }
      assert script.ignore_index == expected
    end
  end

  describe "parse!/2" do
    test "raise InvalidScriptError with an invalid script" do
      assert_raise InvalidScriptError, "Invalid syntax in foo.ex", fn ->
        "<>>>>>>><><>><><>>>>>>>>>>>>>><<><" |> Script.parse!( "foo.ex" )
      end
    end

    test "be identical to parse/2 for valid scripts" do
      source = """
      defmodule Foo do
        def greet do
          "Hello world!"
        end
      end
      """
      expected = source |> Script.parse( "foo.ex" )
      actual   = source |> Script.parse!( "foo.ex" )
      assert expected == actual
    end
  end


  describe "walk/2" do
    setup _ do
      %{
        script: Script.parse( "2 * 3 + 1", "foo.ex" )
      }
    end

    test "run the fn on each node, and return the accumulator", context do
      fun    = fn(node, errors) -> {node, [node | errors]} end
      walked = Script.walk( context.script, fun )
      nodes_walked = [
        1,
        3,
        2,
        {:*, [line: 1], [2, 3]},
        {:+, [line: 1], [{:*, [line: 1], [2, 3]}, 1]}
      ]
      assert nodes_walked == walked
    end

    test "allow you to skip nodes", context do
      fun    = fn(node, errors) -> {[], [node | errors]} end
      walked = Script.walk( context.script, fun )
      nodes_walked = [
        {:+, [line: 1], [{:*, [line: 1], [2, 3]}, 1]}
      ]
      assert nodes_walked == walked
    end
  end
end
