defmodule Dogma.Rule.HardTabsTest do
  use ShouldI

  alias Dogma.Rule.HardTabs
  alias Dogma.Script
  alias Dogma.Error

  defp lint(script) do
    script |> Script.parse( "foo.ex" ) |> HardTabs.test
  end

  should "allow spaces to be used for indenteding." do
    errors = """
    def foo
      :function_body
    end
    """ |> lint
    assert [] == errors
  end

  should "error when tab is used to indent function body." do
    errors = """
    def foo
    \t:function_body
    end
    """ |> lint
    assert [error_on_line(2)] == errors
  end

  should "allow tabs to be used for other reasons." do
    errors = """
    def foo
      ~s"have some tabs:\t\t\t"
    end
    """ |> lint
    assert [] == errors
  end

  should "error when tabs are mixed with spaces" do
    errors = """
    def foo
      \t:function_body
    end
    """ |> lint
    assert [error_on_line(2)] == errors
  end

  defp error_on_line(line) do
    %Error{
      line: Dogma.Script.line(line),
      message: "Hard tab indention. Use spaces instead.",
      rule: HardTabs
    }
  end

end
