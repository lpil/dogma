defmodule Dogma.Rule.FunctionNameTest do
  use RuleCase, for: FunctionName

  should "not error with snake_case names" do
    script = """
    def foo do
    end
    def foo_bar do
    end
    defp private_foo do
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
    end

  should "not error with an unquoted name" do
    script = """
    def unquote(function_name)(_state) do
      {:ok, "something"}
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error with invalid public function names" do
    script = """
    def fooBar do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     FunctionName,
        message:  "Function names should be in snake_case",
        line: 1,
      },
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  should "error with invalid private function names" do
    script = """
    defp fooBar do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     FunctionName,
        message:  "Function names should be in snake_case",
        line: 1,
      },
    ]
    assert expected_errors == Rule.test( @rule, script )
  end
end
