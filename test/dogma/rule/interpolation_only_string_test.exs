defmodule Dogma.Rule.InterpolationOnlyStringTest do
  use ShouldI

  alias Dogma.Rule.InterpolationOnlyString
  alias Dogma.Script
  alias Dogma.Error

  defp lint(script) do
    script
    |> Script.parse!("foo.ex")
    |> InterpolationOnlyString.test
  end

  should "error for an interpolation-only string" do
    errors = ~S"""
    "#{inspect app_servers_pids}"
    """ |> lint
    expected_errors = [
      %Error{
        rule: InterpolationOnlyString,
        message: "Useless string interpolation detected.",
        line: 1,
      }
    ]
    assert expected_errors == errors
  end

  should "not error for a string which does not include an interpolation" do
    errors = """
    "Hello, world!"
    """ |> lint
    assert [] == errors
  end

  should "not error for a string which includes more than an interpolation" do
    errors = ~S"""
    who = "world"
    "Hello #{who}"
    """ |> lint
    assert [] == errors
  end

  should "not error for a quote in a binary literal" do
    errors = ~S"""
    << "\""::utf8, cs::binary >> = string
    """ |> lint
    assert [] == errors
  end
end
