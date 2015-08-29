defmodule Dogma.Rules.ComparisonToBooleanTest do
  use ShouldI

  alias Dogma.Rules.ComparisonToBoolean
  alias Dogma.Script
  alias Dogma.Error

  @expected_errors [
    %Error{
      rule:    ComparisonToBoolean,
      message: "Comparison to a boolean is pointless",
      line:    8
    },
    %Error{
      rule:    ComparisonToBoolean,
      message: "Comparison to a boolean is pointless",
      line:    7
    },
    %Error{
      rule:    ComparisonToBoolean,
      message: "Comparison to a boolean is pointless",
      line:    6
    },
    %Error{
      rule:    ComparisonToBoolean,
      message: "Comparison to a boolean is pointless",
      line:    5
    },
    %Error{
      rule:    ComparisonToBoolean,
      message: "Comparison to a boolean is pointless",
      line:    4
    },
    %Error{
      rule:    ComparisonToBoolean,
      message: "Comparison to a boolean is pointless",
      line:    3
    },
    %Error{
      rule:    ComparisonToBoolean,
      message: "Comparison to a boolean is pointless",
      line:    2
    },
    %Error{
      rule:    ComparisonToBoolean,
      message: "Comparison to a boolean is pointless",
      line:    1
    }
  ]

  defp test(script) do
    script
    |> Script.parse!("foo.ex")
    |> ComparisonToBoolean.test
  end

  should "error with right hand booleans" do
    errors = """
    foo ==  false
    foo ==  true
    foo === false
    foo === true
    foo !=  false
    foo !=  true
    foo !== false
    foo !== true
    """ |> test
    assert @expected_errors == errors
  end

  should "error with lefthand booleans" do
    errors = """
    true  ==  foo
    true  === foo
    true  !=  foo
    true  !== foo
    false ==  foo
    false === foo
    false !=  foo
    false !== foo
    """ |> test
    assert @expected_errors == errors
  end

  should "not error with vars on both sides" do
    errors = """
    foo ==  bar
    foo === bar
    foo !=  bar
    foo !== bar
    foo ==  bar
    foo === bar
    foo !=  bar
    foo !== bar
    """ |> test
    assert [] == errors
  end
end
