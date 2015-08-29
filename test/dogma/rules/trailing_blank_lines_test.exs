defmodule Dogma.Rules.TrailingBlankLinesTest do
  use ShouldI

  alias Dogma.Rules.TrailingBlankLines
  alias Dogma.Script
  alias Dogma.Error

  defp test(source) do
    source |> Script.parse!( "foo.ex" ) |> TrailingBlankLines.test
  end


  should "not error when there are no trailing blank lines" do
    errors = """
    IO.puts 1
    """  |> test
    assert [] == errors
  end

  should "error when there are trailing blank lines" do
    errors = """
    IO.puts 1


    """ |> test
    expected_errors = [
      %Error{
        rule: TrailingBlankLines,
        message: "Blank lines detected at end of file",
        line: 2,
      }
    ]
    assert expected_errors == errors
  end
end
