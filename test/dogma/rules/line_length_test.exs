defmodule Dogma.Rules.LineLengthTest do
  use DogmaTest.Helper

  alias Dogma.Rules.LineLength
  alias Dogma.Script
  alias Dogma.Error

  with "long lines" do
    setup context do
      errors = [
        String.duplicate( "x",  90 ),
        String.duplicate( "y",  30 ),
        String.duplicate( "z", 101 ),
      ] |> Enum.join( "\n" ) |> Script.parse( "foo.ex" ) |> LineLength.test
      %{ errors: errors }
    end
    should_register_errors [
      %Error{
        rule: LineLength,
        message: "Line too long",
        line: 1,
      },
      %Error{
        rule: LineLength,
        message: "Line too long",
        line: 3,
      },
    ]
  end

  with "long lines but with a custom rule config" do
    setup context do
      errors = [
        String.duplicate( "x",  90 ),
        String.duplicate( "y",  30 ),
        String.duplicate( "z", 101 ),
      ]
      |> Enum.join( "\n" )
      |> Script.parse( "foo.ex" )
      |> LineLength.test(max_length: 120)

      %{ errors: errors }
    end
    should_register_no_errors
  end
end
