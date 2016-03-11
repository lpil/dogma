defmodule Dogma.Rule.InterpolationOnlyStringTest do
  use RuleCase, for: InterpolationOnlyString

  test "errors for an interpolation-only string" do
    script = ~S"""
    "#{inspect app_servers_pids}"
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: InterpolationOnlyString,
        message: "Useless string interpolation detected.",
        line: 1,
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "no error for a string which does not include an interpolation" do
    script = """
    "Hello, world!"
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "no error for a string which includes more than an interpolation" do
    script = ~S"""
    who = "world"
    "Hello #{who}"
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "no error for a quote in a binary literal" do
    script = ~S"""
    << "\""::utf8, cs::binary >> = string
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "no error for binary matching" do
    script = """
    <<h::utf8>>
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

end
