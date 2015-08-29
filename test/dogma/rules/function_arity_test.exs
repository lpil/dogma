defmodule Dogma.Rules.FunctionArityTest do
  use ShouldI

  alias Dogma.Rules.FunctionArity
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse!( "foo.ex" ) |> FunctionArity.test
  end

  should "not error with a low arity" do
    errors = """
    def something() do
    end

    def something_else do
    end

    def point(a,b,c,d) do
    end

    def has_defaults(a,b,c,d \\\\[]) do
    end

    def point(a,b,c,{d, e, f}) do
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

  should "erro with a high arity" do
    errors = """
    def point(a,b,c,d,e) do
    end
    """ |> test
    expected_errors = [
      %Error{
        rule:     FunctionArity,
        message:  "Function arity should be 4 or less",
        line: 1,
      }
    ]
    assert expected_errors == errors
  end

  should "be able to customise max arity with" do
    errors = """
    def point(a) do
    end
    def point(a,b,c) do
    end
    """
    |> Script.parse!( "foo.ex" )
    |> FunctionArity.test(max: 2)
    expected_errors = [
      %Error{
        rule:     FunctionArity,
        message:  "Function arity should be 2 or less",
        line: 3,
      }
    ]
    assert expected_errors == errors
  end
end
