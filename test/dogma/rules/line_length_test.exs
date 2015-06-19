defmodule Dogma.Rules.LineLengthTest do
  use ShouldI

  alias Dogma.Rules.LineLength
  alias Dogma.Script
  alias Dogma.Error

  with "long lines" do
    setup context do
      script = "#{ line( 90 ) }\n#{ line( 30 ) }\n#{ line( 101 ) }"
                |> Script.parse( "" )
      %{
        script: LineLength.test( script )
      }
    end

    should "report long lines", context do
      errors = [
        %Error{rule: LineLength, message: "Line too long [101]", position: 3},
        %Error{rule: LineLength, message: "Line too long [90]",  position: 1},
      ]
      assert errors === context.script.errors
    end
  end


  def line(length) do
    1..length
    |> Enum.reduce("", fn(_, acc) -> acc <> "1" end )
  end
end
