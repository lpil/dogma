defmodule Dogma.RunnerTest do
  use ExUnit.Case

  alias Dogma.Error
  alias Dogma.RuleSet.All
  alias Dogma.Runner
  alias Dogma.Script

  test "run_tests/2 run the given rules" do
    errors =
      "1 + 1\n"
      |> Script.parse!("foo.ex")
      |> Runner.run_tests(All.rules)
    assert [] == errors
  end

  test "syntax errors don't run tests or cause crashes" do
    script = """
    defmodule DoclessModule do
      def foo) do # Syntax error here
      end
    end
    """ |> Script.parse("")
    refute script.valid?
    results = Runner.run_tests( script, All.rules )
    assert results == [
      %Error{
        line: 1,
        message: {
          ~s(unexpected token: "),
          ~s(". "do" starting at line 1 is missing terminator "end")
        },
        rule: SyntaxError,
      },
    ]
  end
end
