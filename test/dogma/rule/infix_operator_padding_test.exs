defmodule Dogma.Rule.InfixOperatorPaddingTest do
  use RuleCase, for: InfixOperatorPadding

  defp infix_error(line) do
    %Error{
      rule: InfixOperatorPadding,
      message: "Infix operators should be surrounded by whitespace.",
      line: line
    }
  end

  if Version.match?(System.version, @rule.elixir) do

    test "does not error with padding around infix operators" do
      script = """
      1 + 2 - 2 * 4 = 1 / 2 || 3 < 6 >= 2 <= 1 && false
      2 - (-3 - 4) - 2
      a - 1
      a - b
      g <> h
      1 == 2
      [1 / 2]
      %{:j => 1}
      1 &&& 2
      j |> thing
      cond do true -> false end
      ^x = 1
      """ |> Script.parse!("")

      assert [] == Rule.test(@rule, script)
    end

    test "does not error with unary operators" do
      script = """
      -1
      b = -3
        -3
      !c
      add(-1, -5)
      foo -10, -1
      """ |> Script.parse!("")

      assert [] == Rule.test(@rule, script)
    end

    test "does not error with function arity" do
      script = """
      &length/1
      &Task.await/1
      &Dogma.Task.Thing.work/2
      """ |> Script.parse!("")

      assert [] == Rule.test(@rule, script)
    end

    test "does not error with a multi-line match" do
      script = """
      a =
        1
      """ |> Script.parse!("")

      assert [] == Rule.test(@rule, script)
    end

    test "does not error with range operator" do
      script = """
      1..200
      foo..bar
      """ |> Script.parse!("")

      assert [] == Rule.test(@rule, script)
    end

    test "errors without padding before infix operators" do
      script = """
      1+ 2
      2- 1
      3* 4
      1= 1
      a<= b
      c&& d
      e|| f
      g<> h
      i== 2
      [1/ 2]
      x + y+ z
      2- (-3 - 4)
      (-3 - 4)- 2
      %{:j=> 1}
      k== 1
      j|> thing
      cond do true-> false end
      1&&& 2
      """ |> Script.parse!("")

      expected_errors =
        script.lines
        |> Enum.map(fn {line, _} -> line end)
        |> Enum.map(&infix_error/1)
      assert expected_errors == Rule.test(@rule, script)
    end

    test "errors without padding after infix operators" do
      script = """
      1 +2
      2 -1
      3 *4
      1 =1
      a <=b
      c &&d
      e ||f
      g <>h
      i ==2
      [1 /2]
      x + y +z
      2 -(-3 - 4)
      (-3 - 4) -2
      %{:j =>1}
      k ==1
      j |>thing
      cond do true ->false end
      1 &&&2
      """ |> Script.parse!("")

      expected_errors =
        script.lines
        |> Enum.map(fn {line, _} -> line end)
        |> Enum.map(&infix_error/1)
      assert expected_errors == Rule.test(@rule, script)
    end

    test "allows fn-> by default" do
      script = """
      fn-> something end
      """ |> Script.parse!("")

      assert [] == Rule.test(@rule, script)
    end

    test "disallows fn-> by configuration" do
      rule = %InfixOperatorPadding{fn_arrow_padding: true}
      script = """
      fn-> something end
      """ |> Script.parse!("")

      assert [infix_error(1)] == Rule.test(rule, script)
    end

    test "sigil clause dont match with new elixir release" do
      script = "\~S(test)"
      result = {:sigil_S, [line: 1], [{:<<>>, [line: 1], ["test"]}, []]}
      %{ ast: ast } = script |> Script.parse("")
      assert(ast == result)
    end
    
  end

end
