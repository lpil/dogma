defmodule Dogma.Rule.SemicolonTest do
  use RuleCase, for: Semicolon

  @message "Expressions should not be terminated by semicolons."

  test "error when expression is terminated with semicolon" do
    script = """
    x = 1;
    y = 1;
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: Semicolon,
        message: @message,
        line: 1
      },
      %Error{
        rule: Semicolon,
        message: @message,
        line: 2
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "error when expression is separated by semicolon" do
    script = """
    x = 1; y = 1
    """ |> Script.parse!("")

    expected_errors = [
      %Error{
        rule: Semicolon,
        message: @message,
        line: 1
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "return multiple errors per line if there are multiple semicolons" do
    script = """
    x = 1; y = 1;
    """ |> Script.parse!("")

    expected_errors = [
      %Error{
        rule: Semicolon,
        message: @message,
        line: 1
      },
      %Error{
        rule: Semicolon,
        message: @message,
        line: 1
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "not return any errors when semicolons are in comments" do
    script = """
    # Using a semicolon isn't hard; I once saw a party gorilla do it.
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not return any errors when semicolons are in strings" do
    script = """
    "Using a semicolon isn't hard; I once saw a party gorilla do it."
    'Using a semicolon isn\\'t hard; I once saw a party gorilla do it.'
    ~S(Using a semicolon isn't hard; I once saw a party gorilla do it.)
    ~s(Using a semicolon isn't hard; I once saw a party gorilla do it.)
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "return an error when semicolon is in string interpolation" do
    script = """
    "Foo bar, #\{x = 3; inspect(x)} more string stuff"
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: Semicolon,
        message: @message,
        line: 1
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "return an error when a semicolon is in a nested context" do
    script = """
    if (x = 3; x == 3) do
      true
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: Semicolon,
        message: @message,
        line: 1
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end
end
