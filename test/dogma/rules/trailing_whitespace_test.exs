defmodule Dogma.Rules.TrailingWhitespaceTest do
  use ShouldI

  alias Dogma.Rules.TrailingWhitespace
  alias Dogma.Script
  alias Dogma.Error

  defp test(source) do
    source |> Script.parse!( "foo.ex" ) |> TrailingWhitespace.test
  end

  should "error when there is trailing whitespace" do
    source = "   'hello'\n"
          <> "'how'       \n"
          <> "  'are'\n"
          <> "      'you?'  \n"
    errors = source |> test
    expected_errors = [
      %Error{
        rule: TrailingWhitespace,
        message: "Trailing whitespace detected",
        line: 4,
      },
      %Error{
        rule: TrailingWhitespace,
        message: "Trailing whitespace detected",
        line: 2,
      },
    ]
    assert expected_errors == errors
  end

  should "not error on lines terminated windows style" do
    source = "   'hello'\r\n"
          <> "'how'\r\n"
          <> "  'are'\r\n"
          <> "      'you?'\r\n"
    errors = source |> test
    assert [] == errors
  end

  should "not error for trailing whitespace in triple quote strings" do
    source = ~s("""\n)
          <> ~s(1 + 1       \n)
          <> ~s("""\n)
    errors = source |> test
    assert [] == errors
  end

  with "correction/2" do
    should "strip trailing whitespace" do
      source = "   'hello'\n"
          <> "'how'       \n"
          <> "  'are'\n"
          <> "      'you?'  \n"

      corrected = "   'hello'\n"
          <> "'how'\n"
          <> "  'are'\n"
          <> "      'you?'\n"

      errors = [
        %Error{
          rule: TrailingWhitespace,
          message: "Trailing whitespace detected",
          line: 4,
        },
        %Error{
          rule: TrailingWhitespace,
          message: "Trailing whitespace detected",
          line: 2,
        },
      ]

      assert TrailingWhitespace.correction(source, errors) == corrected
    end

    should "does not change windows style line terminations" do
      source = "   'hello'\r\n"
          <> "'how'\r\n"
          <> "  'are'\r\n"
          <> "      'you?'   \r\n"

      corrected = "   'hello'\r\n"
          <> "'how'\r\n"
          <> "  'are'\r\n"
          <> "      'you?'\r\n"

      error =
        %Error{
          rule: TrailingWhitespace,
          message: "Trailing whitespace detected",
          line: 4,
        }
      assert TrailingWhitespace.correction(source, [error]) == corrected
    end

    should "not correct trailing whitespace in triple quote strings" do
      source = ~s("""\n)
            <> ~s(1 + 1       \n)
            <> ~s("""\n)
            <> "'code'   \n"

      corrected = ~s("""\n)
            <> ~s(1 + 1       \n)
            <> ~s("""\n)
            <> "'code'\n"

      error =
        %Error{
          rule: TrailingWhitespace,
          message: "Trailing whitespace detected",
          line: 4,
        }
      assert TrailingWhitespace.correction(source, [error]) == corrected
    end
  end
end
