defmodule Dogma.Rule.ComparisonToBooleanTest do
  use RuleCase, for: ComparisonToBoolean

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

  test "error with right hand booleans" do
    script = """
    foo ==  false
    foo ==  true
    foo === false
    foo === true
    foo !=  false
    foo !=  true
    foo !== false
    foo !== true
    """ |> Script.parse!("")
    assert @expected_errors == Rule.test( @rule, script )
  end

  test "error with lefthand booleans" do
    script = """
    true  ==  foo
    true  === foo
    true  !=  foo
    true  !== foo
    false ==  foo
    false === foo
    false !=  foo
    false !== foo
    """ |> Script.parse!("")
    assert @expected_errors == Rule.test( @rule, script )
  end

  test "not error with vars on both sides" do
    script = """
    foo ==  bar
    foo === bar
    foo !=  bar
    foo !== bar
    foo ==  bar
    foo === bar
    foo !=  bar
    foo !== bar
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end
end
