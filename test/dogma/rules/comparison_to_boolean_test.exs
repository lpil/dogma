defmodule Dogma.Rules.ComparisonToBooleanTest do
  use DogmaTest.Helper

  alias Dogma.Rules.ComparisonToBoolean
  alias Dogma.Script
  alias Dogma.Error

  @errors [
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

  def test(script) do
    script
    |> Script.parse("foo.ex")
    |> ComparisonToBoolean.test
  end

  with "right hand booleans" do
    setup context do
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
      %{errors: errors}
    end

    should_register_errors @errors
  end

  with "righthand booleans" do
    setup context do
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
      %{errors: errors}
    end

    should_register_errors @errors
  end

  with "vars on both sides" do
    setup context do
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
      %{errors: errors}
    end

    should_register_no_errors
  end
end
