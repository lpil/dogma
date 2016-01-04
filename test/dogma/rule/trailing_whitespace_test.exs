defmodule Dogma.Rule.TrailingWhitespaceTest do
  use RuleCase, for: TrailingWhitespace

  should "error when there is trailing whitespace" do
    source = "   'hello'\n"
          <> "'how'       \n"
          <> "  'are'\n"
          <> "      'you?'  \n"
    script = source |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: TrailingWhitespace,
        message: "Trailing whitespace detected",
        line: 4,
      },
      %Error{
        rule: TrailingWhitespace,
        message: "Trailing whitespace detected",
        line: 2,
      },
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  should "not error on lines terminated windows style" do
    source = "   'hello'\r\n"
          <> "'how'\r\n"
          <> "  'are'\r\n"
          <> "      'you?'\r\n"
    script = source |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error for trailing whitespace in triple quote strings" do
    source = ~s("""\n)
          <> ~s(1 + 1       \n)
          <> ~s("""\n)
    script = source |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end
end
