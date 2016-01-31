defmodule Dogma.RunnerTest do
  use ExUnit.Case

  alias Dogma.Runner
  alias Dogma.RuleSet.All
  alias Dogma.Script

  test "run_tests/2 run the given rules" do
    errors =
      "1 + 1\n"
      |> Script.parse!("foo.ex")
      |> Runner.run_tests(All.rules)
    assert [] == errors
  end
end
