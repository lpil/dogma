defmodule Dogma.Rule.WindowsLineEndingsTest do
  use RuleCase, for: WindowsLineEndings

  test "error for windows line endings" do
    source = "# This line is good\n"
          <> "# This line is bad\r\n"
          <> "# back to good again"
    script = source |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: WindowsLineEndings,
        message: "Windows line ending detected (\r\n)",
        line: 2,
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end
end
