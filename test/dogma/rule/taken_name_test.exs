defmodule Dogma.Rule.TakenNameTest do
  use RuleCase, for: TakenName

  defp lint(script) do
    script |> Script.parse!( "" ) |> fn s -> Rule.test(@rule, s) end.()
  end

  test "allow function names which not overrides standard lib namespace." do
    errors = """
    def ok? do
      :function_body
    end
    """ |> lint
    assert [] == errors
  end

  test "error when function name overrides standard library." do
    errors = """
    def unless do
      :function_body
    end
    """ |> lint
    assert [error_on_line(1, :unless)] == errors
  end

  test "error when private function overrides standard library." do
    errors = """
    defp unless do
      :function_body
    end
    """ |> lint
    assert [error_on_line(1, :unless)] == errors
  end

  test "error when macro name overrides standard library." do
    errors = """
    defmacro require(clause, expression) do
      quote do
        if(!unquote(clause), do: unquote(expression))
      end
    end
    """ |> lint
    assert [error_on_line(1, :require)] == errors
  end

  test "unquoted function name is OK" do
    errors = """
    def unquote(quoted_name)(conn, params) do
      MyApp.Rpc.unquote(quoted_name)(conn, params, __configuration__)
    end
    """ |> lint
    assert [] == errors
  end

  defp error_on_line(line, name) do
    %Error{
      line: Dogma.Script.line(line),
      message: "`#{name}` is already taken and overrides standard library",
      rule: TakenName
    }
  end

end
