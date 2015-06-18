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
        path:   path,
        source: source,
        script: Script.parse( source, path ),
      }
    end

    should "register path", context do
      assert context.path === context.script.path
    end

    should "register source", context do
      assert context.source == context.script.source
    end

    should "assign an empty list of errors", context do
      assert [] == context.script.errors
    end

    should "calculate lines", context do
      lines = [
        {1,  "defmodule Foo do"},
        {2,  "  def greet do"},
        {3,  "    \"Hello world!\""},
        {4,  "  end"},
        {5,  "end"},
      ]
      assert lines == context.script.lines
    end

    should "calculate the quotes abstract syntax tree", context do
      quoted = Code.string_to_quoted( context.source )
      assert quoted == context.script.quoted
    end
  end
end
