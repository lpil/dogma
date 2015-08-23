defmodule Dogma.Rules.FunctionNameTest do
  use DogmaTest.Helper

  alias Dogma.Rules.FunctionName
  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.parse( "foo.ex" ) |> FunctionName.test
  end

  with "valid names" do
    setup context do
      errors = """
      def foo do
      end

      def foo2, do: nil

      def foo_bar2 do
      end

      def foo_bar, do: nil

      defp private_foo do
      end
      """ |> test
      %{ errors: errors }
    end
    should_register_no_errors
  end

  with "valid but weird names" do
    setup context do
      errors = """
      def unquote(function_name)(_state) do
        {:ok, "something"}
      end
      """ |> test
      %{ errors: errors }
    end
    should_register_no_errors
  end

  with "invalid names using def" do
    setup context do
      errors = """
      def fooBar do
      end

      def barFoo, do: nil
      """ |> test
      %{ errors: errors }
    end
    should_register_errors [
      %Error{
        rule:     FunctionName,
        message:  "Function names should be in snake_case",
        line: 4,
      },
      %Error{
        rule:     FunctionName,
        message:  "Function names should be in snake_case",
        line: 1,
      },
    ]
  end

  with "invalid names using defp" do
    setup context do
      errors = """
      defp fooBar do
      end

      defp barFoo, do: nil
      """ |> test
      %{ errors: errors }
    end
    should_register_errors [
      %Error{
        rule:     FunctionName,
        message:  "Function names should be in snake_case",
        line: 4,
      },
      %Error{
        rule:     FunctionName,
        message:  "Function names should be in snake_case",
        line: 1,
      },
    ]
  end
end
