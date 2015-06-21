defmodule Dogma.Rules.LineLengthTest do
  use ShouldI

  alias Dogma.Rules.LineLength
  alias Dogma.Script
  alias Dogma.Error

  with "long lines" do
    setup context do
      x = String.duplicate( "x",  90 )
      y = String.duplicate( "y",  30 )
      z = String.duplicate( "z", 101 )
      script = "#{ x }\n#{ y }\n#{ z }" |> Script.parse( "foo.ex" )
      %{
        script: LineLength.test( script )
      }
    end

    should "report long lines", context do
      errors = [
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
      assert errors == context.script.errors
    end
  end
end
