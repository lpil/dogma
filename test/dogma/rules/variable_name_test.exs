defmodule Dogma.Rules.VariableNameTest do
  use ShouldI

  alias Dogma.Rules.VariableName
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse!( "foo.ex" ) |> VariableName.test
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

  should "not error with destructuring assignment for snake_case" do
    errors = """
    [foo, bar] = foo_bar
    {foo_bar}   = foo_bar
    """ |> test
    assert [] == errors
  end

  with "non snake_case variable names in destructuring assignment" do
    should "error for one member lists" do
      errors = """
      [fooBar] = foo_bar
      """ |> test
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end

    should "error for multi-member lists" do
      errors = """
      [foo, fooBar] = foo_bar
      """ |> test
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end

    should "error for multi-member lists that include literals" do
      errors = """
      [1, fooBar] = foo_bar
      """ |> test
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end

    should "error for non snake_case single member tuples" do
      errors = """
      {fooBar} = baz
      """ |> test
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end

    should "error for non snake_case multi-member tuples" do
      errors = """
      {foo, barBaz} = baz
      """ |> test
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end

    should "error for tuples inside lists and lists inside tuples" do
      errors = """
      [foo, {barBaz}] = foo_bar
      {3, [fooBar]}  = foo_bar
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
        },]
      assert expected_errors == errors
    end
  end
end
