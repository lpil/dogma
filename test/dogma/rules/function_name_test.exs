defmodule Dogma.Rules.FunctionNameTest do
  use DogmaTest.Helper

  alias Dogma.Rules.FunctionName
  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.parse( "foo.ex" ) |> FunctionName.test
  end

  should "not error with snake_case names" do
    errors = """
    def foo do
    end
    def foo_bar do
    end
    defp private_foo do
    end
    """ |> test
    assert [] == errors
    end

  should "not error with an unquoted name" do
    errors = """
    def unquote(function_name)(_state) do
      {:ok, "something"}
    end
    """ |> test
    assert [] == errors
  end

  should "error with invalid public function names" do
    errors = """
    def fooBar do
    end
    """ |> test
    expected_errors = [
      %Error{
        rule:     FunctionName,
        message:  "Function names should be in snake_case",
        line: 1,
      },
    ]
    assert expected_errors == errors
  end

  should "error with invalid private function names" do
    errors = """
    defp fooBar do
    end
    """ |> test
    expected_errors = [
      %Error{
        rule:     FunctionName,
        message:  "Function names should be in snake_case",
        line: 1,
      },
    ]
    assert expected_errors == errors
  end
end
