defmodule Dogma.Rule.QuotesInStringTest do
  use ShouldI

  alias Dogma.Rule.QuotesInString
  alias Dogma.Script
  alias Dogma.Error

  defp lint(script) do
    script |> Script.parse!( "foo.ex" ) |> QuotesInString.test
  end


  should "error for a quote in a string" do
    errors = ~S"""
    "Hello, \" world!"
    """ |> lint
    expected_errors = [
      %Error{
        rule:    QuotesInString,
        message: ~s(Prefer the S sigil for strings containing `"`),
        line: 1,
      }
    ]
    assert expected_errors == errors
  end

  should "not error for a quote free string" do
    errors = """
    "Hello, world!"
    """ |> lint
    assert [] == errors
  end

  should "not error for an interpolation-only string" do
    errors = ~S"""
      "#{inspect app_servers_pids}"
    """ |> lint
    assert [] == errors
  end

  should "not error for a quote in a ~s string" do
    errors = """
    ~s(hello, quote -> " <-)
    """ |> lint
    assert [] == errors
  end

  should "not error for a quote in a ~r regex" do
    errors = """
    ~r/"/
    """ |> lint
    assert [] == errors
  end

  should "not error for a quote in a ~R regex" do
    errors = """
    ~r/"/
    """ |> lint
    assert [] == errors
  end

  should "not error for a quote in a ~S string" do
    errors = """
    ~S(hello, quote -> " <-)
    """ |> lint
    assert [] == errors
  end

  should "not error for a quote in a heredoc" do
    errors = ~s(
    """
    Hey look, a quote -> "
    """) |> lint
    assert [] == errors
  end

  should """
  not error for a quote in a binary literal, as sigils are not valid in the
  binary syntax.
  """ do
    errors = ~S"""
    << "\""::utf8, cs::binary >> = string
    """ |> lint
    assert [] == errors
  end
end
