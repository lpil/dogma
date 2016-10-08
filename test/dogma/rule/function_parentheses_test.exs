defmodule Dogma.Rule.FunctionParenthesesTest do
  use RuleCase, for: FunctionParentheses

  test "not error without parentheses and without argument" do
    script = """
    def foo do
    end
    def foo_bar do
    end
    defp private_foo do
    end
    def baz, do: :baz
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with parentheses and arguments" do
    script = """
    def foo(a) do
    end
    def foo_bar(a, b, c) do
    end
    defp private_foo(x, y) do
    end
    def baz(z), do: z
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "error with public function with parentheses and without arguments" do
    script = """
    def foo() do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: FunctionParentheses,
        message: "Functions declarations should have parentheses if and " <>
          "only if they have arguments",
        line: 1
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "error with private function with parentheses and without arguments" do
    script = """
    defp foo() do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: FunctionParentheses,
        message: "Functions declarations should have parentheses if and " <>
          "only if they have arguments",
        line: 1
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "error with single-line function parentheses and without arguments" do
    script = """
    def foo(), do: :bar
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: FunctionParentheses,
        message: "Functions declarations should have parentheses if and " <>
          "only if they have arguments",
        line: 1
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "error with public function without parentheses and with arguments" do
    script = """
    def foo a, b do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: FunctionParentheses,
        message: "Functions declarations should have parentheses if and " <>
          "only if they have arguments",
        line: 1
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "error with private function without parentheses and with arguments" do
    script = """
    defp foo a, b do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: FunctionParentheses,
        message: "Functions declarations should have parentheses if and " <>
          "only if they have arguments",
        line: 1
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end
end
