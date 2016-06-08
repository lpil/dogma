defmodule Dogma.RunnerTest do
  use ExUnit.Case

  alias Dogma.Error
  alias Dogma.RuleSet.All
  alias Dogma.Runner
  alias Dogma.Script
  alias Dogma.Config

  test "run_tests/2 run the given rules" do
    errors =
      "1 + 1\n"
      |> Script.parse!("foo.ex")
      |> Runner.run_tests(Config.build.rules)
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
    assert [%Error{ line: 1, message: _, rule: SyntaxError }] = results
  end
end
