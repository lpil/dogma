defmodule Dogma.ScriptTest do
  use ShouldI

  alias Dogma.Script
  alias Dogma.Error

  with "Script.parse" do

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
        assert true == context.script.valid?
      end

      should "assigns the quoted abstract syntax tree", context do
        {:ok, ast} = Code.string_to_quoted( context.source )
        assert ast == context.script.ast
      end

      should "include line numbers in the quoted ast" do
        script = Script.parse( "1 + 1", "" )
        assert {:+, [line: 1], [1, 1]} == script.ast
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
        assert false == context.script.valid?
      end

      should "assign [] in place of AST", context do
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


  with ".walk" do
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

    defmodule CustomRules do
      def list do
        [
          {TestRules.TestOne},
          {TestRules.TestTwo, output: "hello world"}
        ]
      end
    end

    setup context do
      %{
        script: Script.parse( "1 + 1", "foo.ex" )
      }
    end

    should "run each test in the provided configuration", context do
      errors = context.script |> Script.run_tests(CustomRules)
      assert [1, "hello world"] == errors
    end
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
end
