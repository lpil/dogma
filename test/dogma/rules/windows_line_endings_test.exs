defmodule Dogma.Rules.WindowsLineEndingsTest do
  use DogmaTest.Helper

  alias Dogma.Rules.WindowsLineEndings
  alias Dogma.Script
  alias Dogma.Error

  with "windows line endings" do
    setup context do
      source = "This line is good\n"
            <> "This line is bad\r\n"
            <> "back to good again"
      script = source |> Script.parse( "foo.ex" ) |> WindowsLineEndings.test
      %{ script: script }
    end

    should_register_errors [
      %Error{
        rule: WindowsLineEndings,
        message: "Windows line ending detected (\r\n)",
        position: 2,
      }
    ]
  end

end
