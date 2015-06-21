defmodule Dogma.Rules.TrailingWhitespaceTest do
  use ShouldI

  alias Dogma.Rules.TrailingWhitespace
  alias Dogma.Script
  alias Dogma.Error

  with "long lines" do
    setup context do
      source = "   'hello'\n"
            <> "'how'       \n"
            <> "  'are'\n"
            <> "      'you?'  \n"
      script = source |> Script.parse( "foo.ex" )
      %{
        script: TrailingWhitespace.test( script )
      }
    end

    should "report trailing whitespace", context do
      errors = [
        %Error{
          rule: TrailingWhitespace,
          message: "Trailing whitespace detected [12]",
          position: 4,
        },
        %Error{
          rule: TrailingWhitespace,
          message: "Trailing whitespace detected [5]",
          position: 2,
        },
      ]
      assert errors === context.script.errors
    end
  end

  with "long lines in triple quote strings" do
    setup context do
      source = ~s("""\n)
            <> ~s(1 + 1       \n)
            <> ~s("""\n)
      script = source |> Script.parse( "foo.ex" )
      %{
        script: TrailingWhitespace.test( script )
      }
    end

    test "not report any errors", _context do
      # https://github.com/lpil/dogma/issues/12
      DogmaTest.pending
      # assert [] == context.script.errors
    end
  end
end
