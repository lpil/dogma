defmodule Dogma.Rules.LiteralInInterpolationTest do
  use ShouldI

  alias Dogma.Rules.LiteralInInterpolation
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse!( "foo.ex" ) |> LiteralInInterpolation.test
  end

  should "not error with a variable or function" do
    errors = """
    IO.puts( "Hi my name is #\{name}")
    """ |> test
    assert [] == errors
  end

  should "error with a literal in the interpolation" do
    errors = """
    IO.puts("Hi my name is #\{'Jose'}")
    """ |> test
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
