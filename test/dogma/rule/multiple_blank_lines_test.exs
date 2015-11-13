defmodule Dogma.Rule.MultipleBlankLinesTest do
  use ShouldI

  alias Dogma.Rule.MultipleBlankLines
  alias Dogma.Script
  alias Dogma.Error

  @message "Multiple consecutive blank lines detected."

  defp lint(script) do
    script |> Script.parse!( "foo.ex" ) |> MultipleBlankLines.test
  end

  should "not error with single empty lines" do
    errors = """
    def foo do
    end

    defp bar do
    end
    """ |> lint
    assert [] == errors
  end

  should "error with multiple empty lines" do
    errors = """
    def foo do
    end


    def bar do
    end

    \n
    def baz do
    end
    """ |> lint
    expected_errors = [
      %Error{
        rule: MultipleBlankLines,
        message: @message,
        line: 4
      },
      %Error{
        rule: MultipleBlankLines,
        message: @message,
        line: 9
      }
    ]
    assert expected_errors == errors
  end

end
