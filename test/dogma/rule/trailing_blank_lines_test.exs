defmodule Dogma.Rule.TrailingBlankLinesTest do
  use RuleCase, for: TrailingBlankLines

  test "not error when there are no trailing blank lines" do
    script = """
    IO.puts 1
    """  |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "error when there are trailing blank lines" do
    script = """
    IO.puts 1


    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: TrailingBlankLines,
        message: "Blank lines detected at end of file",
        line: 2,
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end
end
