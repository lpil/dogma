defmodule Dogma.Rule.WindowsLineEndingsTest do
  use ShouldI

  alias Dogma.Rule.WindowsLineEndings
  alias Dogma.Script
  alias Dogma.Error

  defp lint(source) do
    source |> Script.parse!( "foo.ex" ) |> WindowsLineEndings.test
  end

  should "error for windows line endings" do
    source = "# This line is good\n"
          <> "# This line is bad\r\n"
          <> "# back to good again"
    errors = source |> lint
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
