defmodule Dogma.Rule.MultipleBlankLinesTest do
  use RuleCase, for: MultipleBlankLines

  @message "Multiple consecutive blank lines detected."

  test "not error with 1 empty line" do
    script = """
    def foo do
    end

    defp bar do
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with 2 empty line" do
    script = """
    def foo do
    end


    defp bar do
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "error with more empty lines" do
    script = """
    def foo do
    end
    \n\n
    def baz do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: MultipleBlankLines,
        message: @message,
        line: 5
      },
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "be configurable" do
    rule = %{ @rule | max_lines: 1 }
    script = """
    def foo do
    end


    def baz do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: MultipleBlankLines,
        message: @message,
        line: 4
      },
    ]
    assert expected_errors == Rule.test( rule, script )
  end

end
