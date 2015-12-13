defmodule Dogma.Rule.ExceptionNameTest do
  use RuleCase, for: ExceptionName

  should "not error with a trailing 'Error' in the module name" do
    script = """
    defmodule BadHTTPCodeError do
      defexception [:message]
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error with any other suffix than 'Error' in the module name" do
    script = """
    defmodule BadHTTPCode do
      defexception [:message]
    end
    defmodule BadHTTPCodeException do
      defexception [:message]
    end
    """ |> Script.parse!("")
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
    assert expected_errors == Rule.test( @rule, script )
  end
end
