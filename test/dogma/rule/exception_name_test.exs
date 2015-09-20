defmodule Dogma.Rule.ExceptionNameTest do
  use ShouldI

  alias Dogma.Rule.ExceptionName
  alias Dogma.Script
  alias Dogma.Error

  defp lint(script) do
    script |> Script.parse!( "foo.ex" ) |> ExceptionName.test
  end

  should "not error with a trailing 'Error' in the module name" do
    errors = """
    defmodule BadHTTPCodeError do
      defexception [:message]
    end
    """ |> lint
    assert [] == errors
  end

  should "error with any other suffix than 'Error' in the module name" do
    errors = """
    defmodule BadHTTPCode do
      defexception [:message]
    end
    defmodule BadHTTPCodeException do
      defexception [:message]
    end
    """ |> lint
    expected_errors = [
      %Error{
        rule:     ExceptionName,
        message:  "Exception names should end with 'Error'.",
        line: 4,
      },
      %Error{
        rule:     ExceptionName,
        message:  "Exception names should end with 'Error'.",
        line: 1,
      },
    ]
    assert expected_errors == errors
  end
end
