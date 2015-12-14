defmodule Dogma.Rule.FinalNewlineTest do
  use RuleCase, for: FinalNewline

  should "not error with a final newline" do
    script = "IO.puts 1\n" |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error with no final newline" do
    script = "IO.puts 1\nIO.puts 2\nIO.puts 3" |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: FinalNewline,
        message: "End of file newline missing",
        line: 3,
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end
end
