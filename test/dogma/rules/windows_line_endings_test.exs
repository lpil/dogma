defmodule Dogma.Rules.WindowsLineEndingsTest do
  use DogmaTest.Helper

  alias Dogma.Rules.WindowsLineEndings
  alias Dogma.Script
  alias Dogma.Error

  defp test(source) do
    source |> Script.parse( "foo.ex" ) |> WindowsLineEndings.test
  end

  should "error for windows line endings" do
    source = "# This line is good\n"
          <> "# This line is bad\r\n"
          <> "# back to good again"
    errors = test( source )
    expected_errors = [
      %Error{
        rule: WindowsLineEndings,
        message: "Windows line ending detected (\r\n)",
        line: 2,
      }
    ]
    assert expected_errors == errors
  end
end
