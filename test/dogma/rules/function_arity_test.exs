defmodule Dogma.Rules.FunctionArityTest do
  use ShouldI

  alias Dogma.Rules.FunctionArity
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse!( "foo.ex" ) |> FunctionArity.test
  end

  should "not error with a low arity" do
    errors = ~S"""
    def no_args_with_brackets() do
    end

    def no_args_without_brackets do
    end

    def has_args(a,b,c,d) do
    end

    def has_defaults(a,b,c,d \\ []) do
    end

    defmacro macro(a,b,c) do
    end
    """ |> test
    assert [] == errors
  end

  should "not error with a low arity protocol definition" do
    errors = """
    defprotocol Some.Protocol do
      def run(thing, context)
    end
    """ |> test
    assert [] == errors
  end

  should "error with a high arity" do
    errors = """
    def point(a,b,c,d,e) do
    end
    defmacro volume(a,b,c,d,e) do
    end
    """ |> test
    expected_errors = [
      %Error{
        rule:    FunctionArity,
        message: "Arity of `volume` should be less than 4 (was 5).",
        line: 3,
      },
      %Error{
        rule:    FunctionArity,
        message: "Arity of `point` should be less than 4 (was 5).",
        line: 1,
      },
    ]
    assert expected_errors == errors
  end

  should "be able to customise max arity with" do
    errors = """
    def point(a) do
    end
    def radius(a,b,c) do
    end
    """
    |> Script.parse!( "foo.ex" )
    |> FunctionArity.test(max: 2)
    expected_errors = [
      %Error{
        rule:     FunctionArity,
        message:  "Arity of `radius` should be less than 2 (was 3).",
        line: 3,
      }
    ]
    assert expected_errors == errors
  end
end
