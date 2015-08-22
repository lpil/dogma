defmodule Dogma.Rules.ComparisonToBooleanTest do
  @comp [:==, :===, :!=, :!==]
  @bools [true, false]

  use DogmaTest.Helper

  alias Dogma.Rules.ComparisonToBoolean
  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script
    |> Script.parse("foo.ex")
    |> ComparisonToBoolean.test
  end

  def errors(count) do
    for line_no <- (count..1) do
      %Error{
        rule: ComparisonToBoolean,
        message: "Comparison to a boolean is usually pontless",
        position: line_no
      }
    end
  end

  with "lefthand booleans" do
    setup context do
      errors = for fun <- @comp, bool <- @bools, into: "" do
        "foo #{fun} #{bool}\n"
      end |> test
      %{errors: errors}
    end

    errors(8) |> should_register_errors
  end

  with "righthand booleans" do
    setup context do
      errors = for fun <- @comp, bool <- @bools, into: "" do
        "#{bool} #{fun} foo\n"
      end |> test
      %{errors: errors}
    end

    errors(8) |> should_register_errors
  end

  with "vars on both sides" do
    setup context do
      errors = for fun <- @comp, into: "" do
        "foo #{fun} bar\n"
      end |> test
      %{errors: errors}
    end

    should_register_no_errors
  end
end
