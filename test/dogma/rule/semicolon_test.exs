defmodule Dogma.Rule.SemicolonTest do
  use ShouldI

  @message "Expressions should not be terminated by semicolons."

  alias Dogma.Rule.Semicolon
  alias Dogma.Script
  alias Dogma.Error

  defp apply_rule(script) do
    script
    |> Script.parse!("foo.ex")
    |> Semicolon.test
  end

  should "error when expression is terminated with semicolon" do
    errors = """
    x = 1;
    y = 1;
    """ |> apply_rule

    assert errors == [
      %Error{
        rule: Semicolon,
        message: @message,
        line: {1, 6, 7}
      },
      %Error{
        rule: Semicolon,
        message: @message,
        line: {2, 6, 7}
      }
    ]
  end

  should "error when expression is separated by semicolon" do
    errors = """
    x = 1; y = 1
    """ |> apply_rule

    assert errors == [
      %Error{
        rule: Semicolon,
        message: @message,
        line: {1, 6, 7}
      }
    ]
  end

  should "return multiple errors per line if there are multiple semicolons" do
    errors = """
    x = 1; y = 1;
    """ |> apply_rule

    assert errors == [
      %Error{
        rule: Semicolon,
        message: @message,
        line: {1, 6, 7}
      },
      %Error{
        rule: Semicolon,
        message: @message,
        line: {1, 13, 14}
      }
    ]
  end

  should "not return any errors when semicolons are in comments" do
    errors = """
    # Using a semicolon isn't hard; I once saw a party gorilla do it.
    """ |> apply_rule

    assert errors == []
  end

  should "not return any errors when semicolons are in strings" do
    errors = """
    "Using a semicolon isn't hard; I once saw a party gorilla do it."
    'Using a semicolon isn\\'t hard; I once saw a party gorilla do it.'
    ~S(Using a semicolon isn't hard; I once saw a party gorilla do it.)
    ~s(Using a semicolon isn't hard; I once saw a party gorilla do it.)
    """ |> apply_rule

    assert errors == []
  end

  should "return an error when semicolon is in string interpolation" do
    errors = """
    "Foo bar, #\{x = 3; inspect(x)} more string stuff"
    """ |> apply_rule

    assert errors == [
      %Error{
        rule: Semicolon,
        message: @message,
        line: {1, 18, 19}
      }
    ]
  end

  should "return an error when a semicolon is in a nested context" do
    errors = """
    if (x = 3; x == 3) do
      true
    end
    """ |> apply_rule

    assert errors == [
      %Error{
        rule: Semicolon,
        message: @message,
        line: {1, 10, 11}
      }
    ]
  end
end
