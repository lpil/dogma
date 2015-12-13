defmodule Dogma.Rule.FinalConditionTest do
  use RuleCase, for: FinalCondition

  having "no options are passed" do
    should "not error when last condition is `true`" do
      script = """
      cond do
        1 + 2 == 5 ->
          "Nope"
        true ->
          "Otay!"
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "error when last condition is not `true`" do
      script = """
      cond do
        1 + 2 == 5 ->
          "Nope"
        _ ->
          "Otay!"
      end
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule: FinalCondition,
          message: "Always use true as the last condition of a cond statement",
          line: 4
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end
  end

  having "catch_all option passed" do
    should "not error when last condition is catch_all" do
      script = """
      cond do
        1 + 2 == 5 ->
          "Nope"
        :else ->
          "Otay!"
      end
      """ |> Script.parse!("")
      rule = %{ @rule | catch_all: :else }
      assert [] == Rule.test( rule, script )
    end

    should "error when last condition is not catch_all" do
      script = """
      cond do
        1 + 2 == 5 ->
          "Nope"
        _ ->
          "Otay!"
      end

      cond do
        1 + 2 == 5 ->
          "Nope"
        true ->
          "Otay!"
      end

      cond do
        1 + 2 == 5 ->
          "Nope"
        :otherwise ->
          "Otay!"
      end
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule: FinalCondition,
          message: "Always use :else as the last condition of a cond statement",
          line: 4
        },
        %Error{
          rule: FinalCondition,
          message: "Always use :else as the last condition of a cond statement",
          line: 11
        },
        %Error{
          rule: FinalCondition,
          message: "Always use :else as the last condition of a cond statement",
          line: 18
        }
      ]
    end

    having ":_ sent as a catch-all" do
      should "not error with _" do
        script = """
        cond do
          1 + 2 == 5 ->
            "Nope"
          _ ->
            "Otay!"
        end
        """ |> Script.parse!("")
        rule = %{ @rule | catch_all: :_ }
        assert [] == Rule.test( rule, script )
      end

      should "have a helpfull error message" do
        script = """
        cond do
          1 + 2 == 5 ->
            "Nope"
          true ->
            "Otay!"
        end
        """ |> Script.parse!("")

        expected_errors = [
          %Error{
            rule: FinalCondition,
            message: "Always use '_' as the last condition of a cond statement",
            line: 4
          }
        ]
        rule = %{ @rule | catch_all: :_ }
        assert expected_errors == Rule.test( rule, script )
      end
    end
  end

  having "no catchall condition" do
    should "not error on expression" do
      script = """
      cond do
        1 + 2 == 5 ->
          "Nope"
        1 + 2 == 3 ->
          "Otay!"
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error on function call" do
      script = """
      cond do
        1 + 2 == 5 ->
          "Nope"
        passes? ->
          "Otay!"
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end
  end

  having "a different cond" do
    should "not error when defining a macro called cond" do
      script = """
      defmacro cond
      defmacro cond do end
      defmacro cond()
      defmacro cond() do end
      defmacro cond(foo, bar)
      defmacro cond(foo, bar) do end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error when defining a function called cond" do
      script = """
      def cond
      def cond do end
      def cond()
      def cond() do end
      def cond(foo, bar)
      def cond(foo, bar) do end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error when defining a private function called cond" do
      script = """
      defp cond
      defp cond do end
      defp cond()
      defp cond() do end
      defp cond(foo, bar)
      defp cond(foo, bar) do end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error when calling another cond" do
      script = """
      cond 1, 2, 3
      cond foo
      cond(something)
      cond(4, 6, 7) do
        "Hello"
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end
  end
end
