defmodule Dogma.RunnerTest do
  use ExUnit.Case

  alias Dogma.Error
  alias Dogma.RuleSet.All
  alias Dogma.Runner
  alias Dogma.Script
  alias Dogma.Config

  describe "run_tests/2" do
    test "runs the given rules" do
      errors =
        "1 + 1\n"
        |> Script.parse!("foo.ex")
        |> Runner.run_tests(Config.build.rules)
      assert [] == errors
    end

    test "returns error for rule that uses lines" do
      content =
        "a lonnnnnnnnnnnnnnnnnnnnnnnggggggggggggggggggggggggggggggggggggg"
        <> " liiiiiiiiiiinnnnnnnnnneeeeeeeeeeeeeeee\n"

      errors =
        content
        |> Script.parse!("foo.ex")
        |> Runner.run_tests(Config.build.rules)

      assert [
        %Dogma.Error{
          line: 1,
          message: "Line length should not exceed 80 chars (was 103).",
          rule: Dogma.Rule.LineLength
        }
      ] == errors
    end

    test "returns surfaces error for rule that uses processed_lines" do
      errors =
        "a line with trailing whitespace    \n"
        |> Script.parse!("foo.ex")
        |> Runner.run_tests(Config.build.rules)

      assert [
        %Dogma.Error{
          line: 1,
          message: "Trailing whitespace detected",
          rule: Dogma.Rule.TrailingWhitespace
        }
      ] == errors
    end

    test "returns error for rule that uses tokens" do
      content =
        "a line with a semicolon;\n"
        <> "another line without a semicolon\n"

      errors =
        content
        |> Script.parse!("foo.ex")
        |> Runner.run_tests(Config.build.rules)

      assert [
        %Dogma.Error{
          line: 1,
          message: "Expressions should not be terminated by semicolons.",
          rule: Dogma.Rule.Semicolon
        }
      ] == errors
    end

    test "ignores rule that uses lines" do
      content =
        "a lonnnnnnnnnnnnnnnnnnnnnnnggggggggggggggggggggggggggggggggggggg"
        <> " liiiiiiiiiiinnnnnnnnnneeeeeeeeeeeeeeee # dogma:ignore LineLength\n"

      errors =
        content
        |> Script.parse!("foo.ex")
        |> Runner.run_tests(Config.build.rules)

      assert [] == errors
    end

    test "ignores rule that uses processed_lines" do
      errors =
        "a line with trailing whitespace    # dogma:ignore TrailingWhitespace\n"
        |> Script.parse!("foo.ex")
        |> Runner.run_tests(Config.build.rules)

      assert [] == errors
    end

    test "ignores rule that uses tokens" do
      content =
        "a line with a semicolon; # dogma:ignore Semicolon\n"
        <> "another line without a semicolon\n"

      errors =
        content
        |> Script.parse!("foo.ex")
        |> Runner.run_tests(Config.build.rules)

      assert [] == errors
    end

    test "ignores ignored rule, but not other rule" do
      content =
        "a longgggggggggggggggggggggggggggggggggggggggggggggggggggggg"
        <> " line with a semicolon; # dogma:ignore LineLength\n"

      errors =
        content
        |> Script.parse!("foo.ex")
        |> Runner.run_tests(Config.build.rules)

      assert [
        %Dogma.Error{
          line: 1,
          message: "Expressions should not be terminated by semicolons.",
          rule: Dogma.Rule.Semicolon
        }
      ] == errors
    end

    test "ignores multiple rules" do
      content =
        "a longgggggggggggggggggggggggggggggggggggggggggggggggggggggg"
        <> " line with a semicolon; # dogma:ignore LineLength Semicolon\n"

      errors =
        content
        |> Script.parse!("foo.ex")
        |> Runner.run_tests(Config.build.rules)

      assert [] == errors
    end

    test "doesn't run test or cause crashes when there are syntax errors" do
      script = """
      defmodule DoclessModule do
        def foo) do # Syntax error here
        end
      end
      """ |> Script.parse("")
      refute script.valid?
      results = Runner.run_tests( script, All.rules )
      assert [%Error{ line: _, message: _, rule: SyntaxError }] = results
    end
  end
end
