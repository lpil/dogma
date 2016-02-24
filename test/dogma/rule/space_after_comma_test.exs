defmodule Dogma.Rule.SpaceAfterCommaTest do
  use RuleCase, for: SpaceAfterComma

  should "allow at least 1 spaces after comma" do
    script = """
    def foo do
      [1, 2, 3,  4]
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error when style violation" do
    script = """
    def foo do
      [1,2, 3]
    end
    """ |> Script.parse!("")
    assert [error_on_line(2, 1)] == Rule.test( @rule, script )
  end

  should "allow to change default option" do
    rule   = %SpaceAfterComma{ spaces: 2 }
    script = """
    alias Math.List,  as: List
    """ |> Script.parse!("")
    assert [] == Rule.test( rule, script )
  end

  should "allow 0 spaces after comma" do
    rule   = %SpaceAfterComma{ spaces: 0 }
    script = """
    alias Math.List,as: List
    """ |> Script.parse!("")
    assert [] == Rule.test( rule, script )
  end

  should "allow no spaces on newline" do
    script = """
    %{
      rule:    '__MODULE__',
      message: "Houston we have a problem",
    }
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "ignore comma in strings" do
    script = """
    v = "should,be,tottaly ignored"
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not check strings" do
    script = """
    def foo do
      ["1,", "2", "3\",\""]
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  defp error_on_line(line, spaces) do
    %Error{
      line:    Dogma.Script.line(line),
      message: "Should be #{spaces} spaces after comma",
      rule:    SpaceAfterComma
    }
  end
end
