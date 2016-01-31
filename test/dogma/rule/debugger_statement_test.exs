defmodule Dogma.Rule.DebuggerStatementTest do
  use RuleCase, for: DebuggerStatement

  should "error with a call to IEx.pry" do
    script = """
    def identity(x) do
      IEx.pry
      x
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: DebuggerStatement,
        message: "Possible forgotten debugger statement detected",
        line: 2,
      },
    ]
    assert expected_errors == Rule.test( @rule, script )
  end
end
