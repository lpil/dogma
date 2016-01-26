defmodule Dogma.Rule.TakenNameTest do
  use ShouldI

  alias Dogma.Rule.TakenName
  alias Dogma.Script
  alias Dogma.Error

  defp lint(script) do
    script |> Script.parse( "foo.ex" ) |> TakenName.test
  end

  should "allow function names which not overrides standart library namespace." do
    errors = """
    def ok? do
      :function_body
    end
    """ |> lint
    assert [] == errors
  end

  should "error when function name overrides standart library." do
    errors = """
    def unless do
      :function_body
    end
    """ |> lint
    assert [error_on_line(1, :unless)] == errors
  end

  defp error_on_line(line, name) do
    %Error{
      line: Dogma.Script.line(line),
      message: "`#{name}` is already taken and overrides standart library",
      rule: TakenName
    }
  end

end
