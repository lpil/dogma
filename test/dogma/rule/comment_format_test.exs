defmodule Dogma.Rule.CommentFormatTest do
  use RuleCase, for: CommentFormat

  should "not error with a space after the #" do
    script = """
    1 + 1 # Hello, world!
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error with no content after the #" do
    script = """
    # This is cool.
    #
    1 + 1
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error with multiple #s" do
    script = """
    ####
    ## This is cool.
    ####
    1 + 1
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error with not space after the #" do
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

  should "not error with not multiple spaces after the #" do
    script = """
    "Hi!"
    1 + 1 #     Hello, world!
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end
end
