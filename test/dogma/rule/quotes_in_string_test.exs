defmodule Dogma.Rule.QuotesInStringTest do
  use RuleCase, for: QuotesInString

  should "error for a quote in a string" do
    script = ~S"""
    "Hello, \" world!"
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:    QuotesInString,
        message: ~s(Prefer the S sigil for strings containing `"`),
        line: 1,
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  should "not error for a quote free string" do
    script = """
    "Hello, world!"
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error for an interpolation-only string" do
    script = ~S"""
      "#{inspect app_servers_pids}"
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error for a quote in a ~s string" do
    script = """
    ~s(hello, quote -> " <-)
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error for a quote in a ~r regex" do
    script = """
    ~r/"/
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error for a quote in a ~R regex" do
    script = """
    ~R/"/
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error for a quote in a ~S string" do
    script = """
    ~S(hello, quote -> " <-)
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error for a quote in a heredoc" do
    script = ~s(
    """
    Hey look, a quote -> "
    """) |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should """
  not error for a quote in a binary literal, as sigils are not valid in the
  binary syntax.
  """ do
    script = ~S"""
    << "\""::utf8, cs::binary >> = string
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end
end
