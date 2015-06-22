defmodule Dogma.Rules.FinalNewlineTest do
  use DogmaTest.Helper

  alias Dogma.Rules.FinalNewline
  alias Dogma.Script
  alias Dogma.Error

  with "a final newline" do
    setup context do
      script = "IO.puts 1\n" |> Script.parse( "foo.ex" ) |> FinalNewline.test
      %{ script: script }
    end

    should_register_no_errors
  end


  with "no final newline" do
    setup context do
      script = "IO.puts 1\nIO.puts 2\nIO.puts 3"
                |> Script.parse( "foo.ex" )
                |> FinalNewline.test
      %{ script: script }
    end

    should_register_errors [
      %Error{
        rule: FinalNewline,
        message: "End of file newline missing",
        position: 3,
      }
    ]
  end
end
