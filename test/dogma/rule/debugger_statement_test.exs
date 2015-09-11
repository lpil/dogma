defmodule Dogma.Rule.DebuggerStatementTest do
  use ShouldI

  alias Dogma.Rule.DebuggerStatement
  alias Dogma.Script
  alias Dogma.Error

  should "error with a call to IEx.pry" do
    errors = """
    def identity(x) do
      IEx.pry
      x
    end
    """ |> Script.parse!( "foo.ex" ) |> DebuggerStatement.test
    expected_errors = [
      %Error{
        rule: DebuggerStatement,
        message: "Possible forgotten debugger statement detected",
        line: 2,
      },
    ]
    assert expected_errors == errors
  end
end
