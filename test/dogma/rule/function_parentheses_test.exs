defmodule Dogma.Rule.FunctionParenthesesTest do
  use ShouldI

  alias Dogma.Rule.FunctionParentheses
  alias Dogma.Script
  alias Dogma.Error

  defp lint(script) do
    script |> Script.parse!( "foo.ex" ) |> FunctionParentheses.test
  end

  should "not error without parentheses and without argument" do
    errors = """
    def foo do
    end
    def foo_bar do
    end
    defp private_foo do
    end
    def baz, do: :baz
    """ |> lint
    assert [] == errors
  end

  should "not error with parentheses and arguments" do
    errors = """
    def foo(a) do
    end
    def foo_bar(a, b, c) do
    end
    defp private_foo(x, y) do
    end
    def baz(z), do: z
    """ |> lint
    assert [] == errors
  end

  should "error with public function with parentheses and without arguments" do
    errors = """
    def foo() do
    end
    """ |> lint
    expected_errors = [
      %Error{
        rule: FunctionParentheses,
        message: "Functions declarations should have parentheses if and " <>
          "only if they have arguments",
        line: 1
      }
    ]
    assert expected_errors == errors
  end

  should "error with private function with parentheses and without arguments" do
    errors = """
    defp foo() do
    end
    """ |> lint
    expected_errors = [
      %Error{
        rule: FunctionParentheses,
        message: "Functions declarations should have parentheses if and " <>
          "only if they have arguments",
        line: 1
      }
    ]
    assert expected_errors == errors
  end

  should "error with single-line function parentheses and without arguments" do
    errors = """
    def foo(), do: :bar
    """ |> lint
    expected_errors = [
      %Error{
        rule: FunctionParentheses,
        message: "Functions declarations should have parentheses if and " <>
          "only if they have arguments",
        line: 1
      }
    ]
    assert expected_errors == errors
  end

  should "error with public function without parentheses and with arguments" do
    errors = """
    def foo a, b do
    end
    """ |> lint
    expected_errors = [
      %Error{
        rule: FunctionParentheses,
        message: "Functions declarations should have parentheses if and " <>
          "only if they have arguments",
        line: 1
      }
    ]
    assert expected_errors == errors
  end

  should "error with private function without parentheses and with arguments" do
    errors = """
    defp foo a, b do
    end
    """ |> lint
    expected_errors = [
      %Error{
        rule: FunctionParentheses,
        message: "Functions declarations should have parentheses if and " <>
          "only if they have arguments",
        line: 1
      }
    ]
    assert expected_errors == errors
  end

end
