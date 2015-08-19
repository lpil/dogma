defmodule Dogma.Rules.TrailingWhitespaceTest do
  use DogmaTest.Helper

  alias Dogma.Rules.TrailingWhitespace
  alias Dogma.Script
  alias Dogma.Error

  with "trailing whitespace" do
    setup context do
      source = "   'hello'\n"
            <> "'how'       \n"
            <> "  'are'\n"
            <> "      'you?'  \n"
      errors = source |> Script.parse( "foo.ex" ) |> TrailingWhitespace.test
      %{ errors: errors }
    end

    should_register_errors [
      %Error{
        rule: TrailingWhitespace,
        message: "Trailing whitespace detected",
        position: 4,
      },
      %Error{
        rule: TrailingWhitespace,
        message: "Trailing whitespace detected",
        position: 2,
      },
    ]
  end

  with "lines terminated windows style, \r\n" do
    setup context do
      source = "   'hello'\r\n"
      <> "'how'\r\n"
      <> "  'are'\r\n"
      <> "      'you?'\r\n"
      errors = source |> Script.parse( "foo.ex" ) |> TrailingWhitespace.test
      %{ errors: errors }
    end

    should_register_no_errors
  end

  with "long lines in triple quote strings" do
    setup context do
      source = ~s("""\n)
            <> ~s(1 + 1       \n)
            <> ~s("""\n)
      script = source |> Script.parse( "foo.ex" )
      %{
        errors: TrailingWhitespace.test( script )
      }
    end
    should_register_no_errors
  end
end
