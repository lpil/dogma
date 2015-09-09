defmodule Dogma.Rules.LineLengthTest do
  use ShouldI

  alias Dogma.Rules.LineLength
  alias Dogma.Script
  alias Dogma.Error

  should "error on long lines" do
    errors = [
      String.duplicate( "x",  90 ),
      String.duplicate( "y",  30 ),
      String.duplicate( "z", 101 ),
    ] |> Enum.join( "\n" ) |> Script.parse!( "foo.ex" ) |> LineLength.test
    expected_errors = [
      %Error{
        rule: LineLength,
        message: "Line length should not exceed 80 chars (was 90).",
        line: 1,
      },
      %Error{
        rule: LineLength,
        message: "Line length should not exceed 80 chars (was 101).",
        line: 3,
      },
    ]
    assert expected_errors == errors
  end

  should "allow the lien length to be configured" do
    errors = [
      String.duplicate( "x",  90 ),
      String.duplicate( "y",  30 ),
      String.duplicate( "z", 101 ),
    ]
    |> Enum.join( "\n" )
    |> Script.parse!( "foo.ex" )
    |> LineLength.test(max_length: 100)
    expected_errors = [
      %Error{
        rule: LineLength,
        message: "Line length should not exceed 100 chars (was 101).",
        line: 3,
      },
    ]
    assert expected_errors == errors
  end
end
