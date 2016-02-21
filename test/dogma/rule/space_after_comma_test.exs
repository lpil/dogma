defmodule Dogma.Rule.SpaceAfterComma do
  use RuleCase, for: SpaceAfterComma

  should "allow default number of spaces after comma" do
    script = """
    def foo do
      [1, 2, 3]
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error when style violation" do
    script = """
    def foo do
      [1,  2,   3]
    end
    """ |> Script.parse!("")
    expected_errors = [ error_on_line(2, 1)]
    assert expected_errors == Rule.test( @rule, script )
  end

  should "allow to change default option." do
    rule   = %SpaceAfterComma{ spaces: 100 }
    script = """
    alias Math.List,  as: List
    """ |> Script.parse!("")
    assert [] == Rule.test( rule, script )
  end

  defp error_on_line(line, spaces) do
    %Error{
      line: Dogma.Script.line(line),
      message: "Should be #{spaces} spaces after comma",
      rule: SpaceAfterComma
    }
  end
end
