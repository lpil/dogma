defmodule Dogma.Rules.LineLengthTest do
  use DogmaTest.Helper

  alias Dogma.Rules.LineLength
  alias Dogma.Script
  alias Dogma.Error

  with "long lines" do
    setup context do
      script = [
        String.duplicate( "x",  90 ),
        String.duplicate( "y",  30 ),
        String.duplicate( "z", 101 ),
      ] |> Enum.join( "\n" ) |> Script.parse( "foo.ex" ) |> LineLength.test
      %{ script: script }
    end

    should_register_errors [
      %Error{
        rule: LineLength,
        message: "Line too long [101]",
        position: 3,
      },
      %Error{
        rule: LineLength,
        message: "Line too long [90]",
        position: 1,
      },
    ]
  end
end
