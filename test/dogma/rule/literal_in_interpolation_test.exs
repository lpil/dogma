defmodule Dogma.Rule.LiteralInInterpolationTest do
  use ShouldI

  alias Dogma.Rule.LiteralInInterpolation
  alias Dogma.Script
  alias Dogma.Error

  defp lint(script) do
    script |> Script.parse!( "foo.ex" ) |> LiteralInInterpolation.test
  end

  should "not error with a variable or function" do
    errors = """
    IO.puts( "Hi my name is #\{name}")
    """ |> lint
    assert [] == errors
  end

  should "error with a literal in the interpolation" do
    errors = """
    IO.puts("Hi my name is #\{'Jose'}")
    """ |> lint
    expected_errors = [
      %Error{
        rule:     LiteralInInterpolation,
        message:  "Literal value found in interpolation",
        line: 1,
      }
    ]

    assert expected_errors == errors
  end
end
