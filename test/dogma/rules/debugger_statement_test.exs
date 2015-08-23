defmodule Dogma.Rules.DebuggerStatementTest do
  use DogmaTest.Helper

  alias Dogma.Rules.DebuggerStatement
  alias Dogma.Script
  alias Dogma.Error

  with "a call to IEx.pry" do
    setup context do
      source = """
      def identity(x) do
        IEx.pry
        x
      end
      """
      errors = source |> Script.parse( "foo.ex" ) |> DebuggerStatement.test
      %{ errors: errors }
    end

    should_register_errors [
      %Error{
        rule: DebuggerStatement,
        message: "Possible forgotten debugger statement detected",
        line: 2,
      },
    ]
  end
end
