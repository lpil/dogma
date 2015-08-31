defmodule Dogma.Rules.HardTabsTest do
  use ShouldI

  alias Dogma.Rules.HardTabs
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse( "foo.ex" ) |> HardTabs.test
  end

  should "allow spaces to be used for indenteding." do
    errors = """
    def
      :function_body
    end
    """ |> test
    assert [] == errors
  end

  should "error when tab is used to indent function body." do
    errors = """
    def
    \t:function_body
    end
    """ |> test
    assert [error_on_line(2)] == errors
  end

  should "allow tabs to be used for other reasons." do
    errors = """
    def
      ~s"have some tabs:\t\t\t"
    end
    """ |> test
    assert [] == errors
  end

  defp error_on_line(line) do
    %Error{
      line: line,
      message: "Hard tab indention. Use spaces instead.",
      rule: HardTabs
    }
  end

end
