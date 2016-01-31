defmodule Dogma.Rule.FunctionArityTest do
  use RuleCase, for: FunctionArity

  should "not error with a low arity" do
    script = ~S"""
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
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error with a low arity protocol definition" do
    script = """
    defprotocol Some.Protocol do
      def run(thing, context)
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error with a high arity" do
    script = """
    def point(a,b,c,d,e) do
    end
    defmacro volume(a,b,c,d,e) do
    end
    """ |> Script.parse!("")
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
    assert expected_errors == Rule.test( @rule, script )
  end

  should "be able to customise max arity with" do
    script = """
    def point(a) do
    end
    def radius(a,b,c) do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     FunctionArity,
        message:  "Arity of `radius` should be less than 2 (was 3).",
        line: 3,
      }
    ]
    rule = %{ @rule | max: 2 }
    assert expected_errors == Rule.test( rule, script )
  end
end
