defmodule Dogma.Rule.FinalNewlineTest do
  use ShouldI

  alias Dogma.Rule.FinalNewline
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse!( "foo.ex" ) |> FinalNewline.test
  end

  should "not error with a final newline" do
    errors = "IO.puts 1\n" |> test
    assert [] == errors
  end


  should "error with no final newline" do
    errors = "IO.puts 1\nIO.puts 2\nIO.puts 3" |> test
    expected_errors = [
      %Error{
        rule: FinalNewline,
        message: "End of file newline missing",
        line: 3,
      }
    ]
    assert expected_errors == errors
  end
end
