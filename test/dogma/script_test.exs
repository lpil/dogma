defmodule Dogma.ScriptTest do
  use ShouldI

  alias Dogma.Script

  with "Script.parse" do
    setup context do
      path = "lib/foo.ex"
      source = ~s"""
      defmodule Foo do
        def greet do
          "Hello world!"
        end
      end
      """
      %{
        source: source,
        script: Script.parse( source, path ),
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

    should "assigns the quotes abstract syntax tree", context do
      {:ok, ast} = Code.string_to_quoted( context.source )
      assert ast == context.script.ast
    end

    should "include line numbers in the quoted ast" do
      script = Script.parse( "1 + 1", "" )
      assert {:+, [line: 1], [1, 1]} == script.ast
    end
  end
end
