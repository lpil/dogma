defmodule Dogma.Rule.CommentFormatTest do
  use ShouldI

  alias Dogma.Rule.CommentFormat
  alias Dogma.Script
  alias Dogma.Error

  defp lint(script) do
    script |> Script.parse!( "foo.ex" ) |> CommentFormat.test
  end

  should "not error with a space after the #" do
    errors = """
    1 + 1 # Hello, world!
    """ |> lint
    assert [] == errors
  end

  should "not error with no content after the #" do
    errors = """
    # This is cool.
    #
    1 + 1
    """ |> lint
    assert [] == errors
  end

  should "error with not space after the #" do
    errors = """
    1 + 1 #Hello, world!
    """ |> lint
    expected_errors = [
      %Error{
        line: 1,
        message: "Comments should start with a single space",
        rule: CommentFormat
      }
    ]
    assert expected_errors == errors
  end

  should "not error with not multiple spaces after the #" do
    errors = """
    "Hi!"
    1 + 1 #     Hello, world!
    """ |> lint
    expected_errors = [
    ]
    assert expected_errors == errors
  end
end
