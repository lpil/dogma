defmodule Dogma.Rules.TrailingBlankLinesTest do
  use DogmaTest.Helper

  alias Dogma.Rules.TrailingBlankLines
  alias Dogma.Script
  alias Dogma.Error

  with "no trailing blank lines" do
    setup context do
      errors = """
      IO.puts 1
      """  |> test
      %{
        errors: errors
      }
    end

    should_register_no_errors
  end


  with "trailing blank lines" do
    setup context do
      errors = """
      IO.puts 1


      """ |> test
      %{ errors: errors }
    end

    should_register_errors [
      %Error{
        rule: TrailingBlankLines,
        message: "Blank lines detected at end of file",
        position: 2,
      }
    ]
  end

  defp test(source) do
    source |> Script.parse( "foo.ex" ) |> TrailingBlankLines.test
  end
end
