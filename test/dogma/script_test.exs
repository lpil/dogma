defmodule Dogma.ScriptTest do
  use ShouldI

  alias Dogma.Error
  alias Dogma.Script
  alias Dogma.Script.InvalidScriptError

  with "parse/2" do

    with "a valid script" do
      setup context do
        source = """
        defmodule Foo do
          def greet do
            "Hello world!"
          end
        end
        """
        %{
          source: source,
          script: Script.parse( source, "lib/foo.ex" ),
        }
      end

      should "assign path", context do
        assert "lib/foo.ex" == context.script.path
      end

      should "assign source", context do
        assert context.source == context.script.source
      end

      should "assign processed source", context do
        processed_source = """
        defmodule Foo do
          def greet do
            ""
          end
        end
        """
        assert processed_source == context.script.processed_source
      end

      should "assign an empty list of errors", context do
        assert [] == context.script.errors
      end

      should "assigns lines", context do
        lines = [
          {1,  ~s(defmodule Foo do)},
          {2,  ~s(  def greet do)},
          {3,  ~s(    "Hello world!")},
          {4,  ~s(  end)},
          {5,  ~s(end)},
        ]
        assert lines == context.script.lines
      end

      should "assigns processed lines", context do
        lines = [
          {1,  ~s(defmodule Foo do)},
          {2,  ~s(  def greet do)},
          {3,  ~s(    "")},
          {4,  ~s(  end)},
          {5,  ~s(end)},
        ]
        assert lines == context.script.processed_lines
      end

      should "assign valid? as true", context do
        assert context.script.valid?
      end

      should "assigns the quoted abstract syntax tree", context do
        {:ok, ast} = Code.string_to_quoted( context.source )
        assert ast == context.script.ast
      end

      should "include line numbers in the quoted ast" do
        script = Script.parse( "1 + 1", "" )
        assert {:+, [line: 1], [1, 1]} == script.ast
      end

      should "assigns the tokenized source", context do
        {:ok, _, tokens} = context.source
                            |> String.to_char_list
                            |> :elixir_tokenizer.tokenize( 1, [] )
        assert tokens == context.script.tokens
      end
    end


    with "an invalid script" do
      setup context do
        source = ~s"""
        <>>>>>>><><>><><>>>>>>>>>>>>>><<><
        """
        %{
          script: Script.parse( source, "" ),
        }
      end

      should "assign valid? as false", context do
        refute context.script.valid?
      end

      should "assign [] in place of AST", context do
        assert [] == context.script.ast
      end

      should "assign [] in place of tokens", context do
        assert [] == context.script.ast
      end

      should "assign a syntax error", context do
        error = %Error{
          rule: SyntaxError,
          message: ~s[missing terminator: >> (for "<<" starting at line 1)],
          line: 1,
        }
        assert [error] == context.script.errors
      end
    end


    with "a script with trailing blank lines" do
      setup context do
        source = """
        1 + 2


        """
        %{
          source: source,
          script: Script.parse( source, "lib/foo.ex" ),
        }
      end

      should "preserve the extra blank lines", context do
        lines = [
          {1, "1 + 2"},
          {2, ""},
          {3, ""},
        ]
        assert lines == context.script.lines
      end
    end
  end

  with "parse!/2" do
    should "raise InvalidScriptError with an invalid script" do
      assert_raise InvalidScriptError, fn ->
        "<>>>>>>><><>><><>>>>>>>>>>>>>><<><" |> Script.parse!( "foo.ex" )
      end
    end

    should "be identical to parse/2 for valid scripts" do
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


  with "walk/2" do
    setup context do
      %{
        script: Script.parse( "2 * 3 + 1", "foo.ex" )
      }
    end

    should "run the fn on each node, and return the accumulator", context do
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

    should "allow you to skip nodes", context do
      fun    = fn(node, errors) -> {[], [node | errors]} end
      walked = Script.walk( context.script, fun )
      nodes_walked = [
        {:+, [line: 1], [{:*, [line: 1], [2, 3]}, 1]}
      ]
      assert nodes_walked == walked
    end
  end


  with "run_tests/1" do

    setup context do
      %{
        script: Script.parse( "1 + 1", "foo.ex" ),
        rules: [
          {TestRules.TestOne},
          {TestRules.TestTwo, output: "hello world"}
        ],
      }
    end

    should "run the given rules", context do
      errors = context.script |> Script.run_tests(context.rules)
      assert [1, "hello world"] == errors
    end
  end

  with "repair/1" do
    should "do nothing if there are no violations" do
      script =
        %Script{errors: [], source: "Test"}
        |> Script.repair(FakeFile)
      assert is_nil(script.corrected_source)
    end

    should "do nothing if the violated rules havn't implemented correction/2" do
      error =
        %Error{
          rule: Dogma.Rules.TestRules.TestOne,
        }
      script =
        %Script{errors: [error]}
        |> Script.repair(FakeFile)

      assert is_nil(script.corrected_source)
    end

    should "build a corrected source if the rule implmented correction/2" do
      error =
        %Error{
          rule: Dogma.Rules.TestRules.WithCorrection,
        }
      script =
        %Script{errors: [error], source: ""}
        |> Script.repair(FakeFile)

      assert "Correction Output" == script.corrected_source
    end

    should "two corrections should not clobber each other" do
      error =
        %Error{
          rule: Dogma.Rules.TestRules.WithCorrection,
        }
      other_error =
        %Error{
          rule: Dogma.Rules.TestRules.OtherWithCorrection,
        }
      script =
        %Script{errors: [error, other_error], source: ""}
        |> Script.repair(FakeFile)

      assert "Two Times Correction Output" == script.corrected_source
    end
  end
end

defmodule FakeFile do
  def write(_path, _content, _opts \\ []) do
  end
end

defmodule Dogma.Rules.TestRules do
  defmodule TestOne do
    def test(_) do
      [1]
    end
  end

  defmodule TestTwo do
    def test(_, output: custom_out) do
      [custom_out]
    end
  end

  defmodule WithCorrection do
    def correction(source,_) do
      source <> "Correction Output"
    end
  end

  defmodule OtherWithCorrection do
    def correction(source,_) do
      source <> "Two Times "
    end
  end
end
