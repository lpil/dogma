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

      should "register path", context do
        assert "lib/foo.ex" == context.script.path
      end

      should "register source", context do
        assert context.source == context.script.source
      end

      should "assign an empty list of errors", context do
        assert [] == context.script.errors
      end

      should "assigns lines", context do
        lines = [
          {1,  "defmodule Foo do"},
          {2,  "  def greet do"},
          {3,  "    \"Hello world!\""},
          {4,  "  end"},
          {5,  "end"},
        ]
        assert lines == context.script.lines
      end

      should "assign valid? as true", context do
        assert true == context.script.valid?
      end

      should "assigns the quotes abstract syntax tree", context do
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

      should "assign parse error in place of ast", context do
        error = {
          :error,
          {2, "missing terminator: >> (for \"<<\" starting at line 1)", ""}
        }
        assert error == context.script.ast
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


  with ".add_error" do
    should "add the error. gosh." do
      error  = %Error{ rule: MustBeGood, message: "Not good!", position: 5 }
      script = %Script{} |> Script.register_error( error )
      assert [error] == script.errors
    end
  end

  with ".walk" do
    setup context do
      %{
        script: Script.parse( "2 * 3", "foo.ex" )
      }
    end

    should "run the fn on each node, with errors as an accumulator", context do
      fun    = fn(node, errors) -> {node, [node | errors]} end
      walked = Script.walk( context.script, fun )
      errors = [ {:*, [line: 1], [2, 3]}, 3, 2, ]
      assert %Script{ context.script | errors: errors } == walked
    end
  end


  with ".run_tests" do
    defmodule TestOne do
      def test(script) do
        %Script{ script | errors: [1 | script.errors] }
      end
    end
    defmodule TestTwo do
      def test(script) do
        %Script{ script | errors: [2 | script.errors] }
      end
    end

    setup context do
      %{
        script: Script.parse( "1 + 1", "foo.ex" )
      }
    end

    should "run the tests", context do
      script = context.script |> Script.run_tests([TestOne, TestTwo])
      assert [2, 1] == script.errors
    end
  end
end
