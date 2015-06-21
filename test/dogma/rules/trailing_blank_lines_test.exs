defmodule Dogma.Rules.TrailingBlankLinesTest do
  use ShouldI

  alias Dogma.Rules.TrailingBlankLines
  alias Dogma.Script
  alias Dogma.Error

  with "no trailing blank lines" do
    setup context do
      script = """
      IO.puts 1
      """ |> Script.parse( "foo.ex" )
      %{
        script: TrailingBlankLines.test( script )
      }
    end

    should "register no errors", context do
      assert [] == context.script.errors
    end
  end


  with "trailing blank lines" do
    setup context do
      script = """
      IO.puts 1


      """ |> Script.parse( "foo.ex" )
      %{
        script: TrailingBlankLines.test( script )
      }
    end

    should "register an error", context do
      error = %Error{
        rule: TrailingBlankLines,
        message: "Blank lines detected at end of file",
        position: 2,
      }
      assert [error] == context.script.errors
    end
  end
end
