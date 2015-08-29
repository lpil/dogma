defmodule Dogma.Rules.VariableNameTest do
  use ShouldI

  alias Dogma.Rules.VariableName
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse( "foo.ex" ) |> VariableName.test
  end

  should "not error for snake_case names" do
    errors = """
    x       = :ok
    foo     = :ok
    foo_bar = :ok
    """ |> test
    assert [] == errors
  end

  should "error for non snake_case names" do
    errors = """
    fooBar  = :error
    foo_Bar = :error
    """ |> test
    expected_errors = [
      %Error{
        rule:     VariableName,
        message:  "Variable names should be in snake_case",
        line: 2,
      },
      %Error{
        rule:     VariableName,
        message:  "Variable names should be in snake_case",
        line: 1,
      },
    ]
    assert expected_errors == errors
  end

  should "not error with destructuring assignment" do
    errors = """
    [foo, bar] = foo_bar
    {fooBar}   = foo_bar
    """ |> test
    # For now we just want to show that we can not explode when the thing on
    # the left hand side of the match operator isn't just a variable name.
    assert [] == errors
  end
end
