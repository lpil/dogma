defmodule Dogma.Rule.LineLengthTest do
  use RuleCase, for: LineLength

  test "error on long lines" do
    script = [
      String.duplicate( "x",  90 ),
      String.duplicate( "y",  30 ),
      String.duplicate( "z", 101 ),
    ] |> to_script
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
    assert expected_errors == Rule.test( @rule, script )
  end

  test "allow the line length to be configured" do
    rule   = %LineLength{ max_length: 100 }
    script = [
      String.duplicate( "x",  90 ),
      String.duplicate( "y",  30 ),
      String.duplicate( "z", 101 ),
    ] |> to_script
    expected_errors = [
      %Error{
        rule: LineLength,
        message: "Line length should not exceed 100 chars (was 101).",
        line: 3,
      },
    ]
    assert expected_errors == Rule.test( rule, script )
  end


  defp to_script(lines) do
    lines |> Enum.join( "\n" ) |> Script.parse!( "foo.ex" )
  end
end
