defmodule Dogma.Rule.InterpolationOnlyStringTest do
  use RuleCase, for: InterpolationOnlyString

  def error_on_line(n) do
    %Error{
      rule: InterpolationOnlyString,
      message: "Useless string interpolation detected.",
      line: n,
    }
  end

  test "errors for an interpolation-only string" do
    script = ~S"""
    "#{inspect app_servers_pids}"
    """ |> Script.parse!("")
    expected_errors = [error_on_line(1)]
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

  test "no error for ~r interpolation" do
    script = ~S"""
    ~r/#{bar}/
    "#{bar}"
    """ |> Script.parse!("")
    assert [error_on_line(2)] == Rule.test( @rule, script )
  end
end
