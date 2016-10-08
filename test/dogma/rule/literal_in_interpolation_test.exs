defmodule Dogma.Rule.LiteralInInterpolationTest do
  use RuleCase, for: LiteralInInterpolation

  test "not error with a variable or function" do
    script = ~S"""
    IO.puts( "Hi my name is #{name}")
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "error with a literal in the interpolation" do
    script = ~S"""
    IO.puts("Hi my name is #{'Jose'}")
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     LiteralInInterpolation,
        message:  "Literal value found in interpolation",
        line: 1,
      }
    ]

    assert expected_errors == Rule.test( @rule, script )
  end
end
