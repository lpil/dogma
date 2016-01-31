defmodule Dogma.Rule.HardTabsTest do
  use RuleCase, for: HardTabs

  should "allow spaces to be used for indenting." do
    script = """
    def foo do
      :function_body
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error when tab is used to indent function body." do
    script = """
    def foo do
    \t:function_body
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        line: 2,
        message: "Hard tab indention. Use spaces instead.",
        rule: HardTabs
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  should "allow tabs to be used for other reasons." do
    script = """
    def foo do
      ~s"have some tabs:\t\t\t"
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error when tabs are mixed with spaces" do
    script = """
    def foo do
      \t:function_body
    end
    """ |> Script.parse!("")
    assert [error_on_line(2)] == Rule.test( @rule, script )
  end

  defp error_on_line(line) do
    %Error{
      line: Dogma.Script.line(line),
      message: "Hard tab indention. Use spaces instead.",
      rule: HardTabs
    }
  end
end
