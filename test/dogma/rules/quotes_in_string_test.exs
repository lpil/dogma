defmodule Dogma.Rules.QuotesInStringTest do
  use DogmaTest.Helper

  alias Dogma.Rules.QuotesInString
  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.parse( "foo.ex" ) |> QuotesInString.test
  end

  with "a quote free string" do
    setup context do
      errors = """
      "Hello, world!"
      """ |> test
      %{ errors: errors }
    end
    should_register_no_errors
  end

  with "a quote in a ~s string" do
    setup context do
      errors = """
      ~s(hello, quote -> " <-)
      """ |> test
      %{ errors: errors }
    end
    should_register_no_errors
  end

  with "a quote in a ~r regex" do
    setup context do
      errors = """
      ~r/"/
      """ |> test
      %{ errors: errors }
    end
    should_register_no_errors
  end

  with "a quote in a ~R regex" do
    setup context do
      errors = """
      ~r/"/
      """ |> test
      %{ errors: errors }
    end
    should_register_no_errors
  end

  with "a quote in a ~S string" do
    setup context do
      errors = """
      ~S(hello, quote -> " <-)
      """ |> test
      %{ errors: errors }
    end
    should_register_no_errors
  end

  with "a quote in a heredoc" do
    setup context do
      errors = ~s(
      """
      Hey look, a quote -> "
      """) |> test
      %{ errors: errors }
    end
    should_register_no_errors
  end

  with ~s(a quote in a "" string) do
    setup context do
      errors = ~S("This here -> \" <- is a quote") |> test
      %{ errors: errors }
    end
    should_register_errors [
      %Error{
        rule:     QuotesInString,
        message:  ~s(Prefer the S sigil for strings containing `"`),
        line: nil, # FIXME: How do we get the line number for a string?
      }
    ]
  end

  with "a quote in a binary pattern, where sigils are not valid" do
    setup context do
      errors = ~S(<< "\""::utf8, cs::binary >> = string) |> test
      %{ errors: errors }
    end
    should_register_no_errors
  end
end
