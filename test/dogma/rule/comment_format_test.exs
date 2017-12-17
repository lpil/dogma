defmodule Dogma.Rule.CommentFormatTest do
  use RuleCase, for: CommentFormat

  test "not error with a space after the #" do
    script = """
    1 + 1 # Hello, world!
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with no content after the #" do
    script = """
    # This is cool.
    #
    1 + 1
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "error with not space after the #" do
    script = """
    1 + 1 #Hello, world!
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        line: 1,
        message: "Comments should start with a single space",
        rule: CommentFormat
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "not error with multiple #'s with allow_multiple_hashes" do
    script = """
    ####
    ## This is cool.
    ####
    1 + 1
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "error with multiple #'s without allow_multiple_hashes" do
    rule = %CommentFormat{ allow_multiple_hashes: false }
    script = """
    ## This is not cool.
    1 + 1
    """ |> Script.parse!("")

    expected_errors = [
      %Error{
        line: 1,
        message: "Comments should start with a single space",
        rule: CommentFormat
      }
    ]
    assert expected_errors == Rule.test( rule, script )
  end

  test "not error with not multiple spaces after the #" do
    script = """
    "Hi!"
    1 + 1 #     Hello, world!
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with shebang-style comment as first line" do
    script = """
    #!/usr/bin/env elixir
    1 + 1 # Other stuff here
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with shebang-style comment as first line, with a space" do
    script = """
    #! /usr/bin/env elixir
    1 + 1 # Other stuff here
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "error with shebang-style comment not as as first line" do
    script = """
    2 + 3
    #!/usr/bin/env elixir
    1 + 1 # Other stuff here
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        line: 2,
        message: "Comments should start with a single space",
        rule: CommentFormat
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end
end
