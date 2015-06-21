defmodule Dogma.Rules.FinalNewlineTest do
  use ShouldI

  alias Dogma.Rules.FinalNewline
  alias Dogma.Script
  alias Dogma.Error

  with "a final newline" do
    setup context do
      script = "IO.puts 1\nIO.puts 2\nIO.puts 3\n" |> Script.parse( "foo.ex" )
      %{
        script: FinalNewline.test( script )
      }
    end

    should "register no errors", context do
      assert [] == context.script.errors
    end
  end


  with "no final newline" do
    setup context do
      script = "IO.puts 1\nIO.puts 2\nIO.puts 3" |> Script.parse( "foo.ex" )
      %{
        script: FinalNewline.test( script )
      }
    end

    should "register an error", context do
      error = %Error{
        rule: FinalNewline,
        message: "End of file newline missing",
        position: 3,
      }
      assert [error] == context.script.errors
    end
  end
end
