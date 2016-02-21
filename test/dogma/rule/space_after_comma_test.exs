defmodule Dogma.Rule.SpaceAfterCommaTest do
  use RuleCase, for: SpaceAfterComma

  defp lint(script, rule) do
    script |> Script.parse!( "" ) |> fn s -> Rule.test(rule, s) end.()
  end
  defp lint(script) do
    lint script, @rule
  end

  should "allow default number of spaces after comma" do
    errors = """
    def foo do
      [1, 2, 3]
    end
    """ |> lint
    assert [] == errors
  end

  should "error when style violation" do
    errors = """
    def foo do
      [1,  2,   3]
    end
    """ |> lint
    assert errors == [error_on_line(2, 1)]
  end

  should "allow to change default option" do
    rule   = %SpaceAfterComma{ spaces: 2 }
    errors = """
    alias Math.List,  as: List
    """ |> lint(rule)
    assert [] == errors
  end

  should "allow 0 spaces after comma" do
    rule   = %SpaceAfterComma{ spaces: 0 }
    errors = """
    alias Math.List,as: List
    """ |> lint(rule)
    assert [] == errors
  end

  should "allow no spaces on newline" do
    errors = """
    %{
      rule:    '__MODULE__',
      message: "Houston we have a problem",
    }
    """ |> lint
    assert [] == errors
  end

  defp error_on_line(line, spaces) do
    %Error{
      line: Dogma.Script.line(line),
      message: "Should be #{spaces} spaces after comma",
      rule: SpaceAfterComma
    }
  end
end
