defmodule Dogma.Rule.LiteralInConditionTest do
  use RuleCase, for: LiteralInCondition

  having "a variable/function argument" do
    should "not error for if" do
      script = """
      if feeling_tired do
        have_an_early_night
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error for unless" do
      script = """
      unless feeling_sleepy do
        a_little_dance
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error for case" do
      script = """
      case status do
        :hyped -> run_like_the_wind
        _      -> dawdle
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end
  end


  having "a literal argument" do
    should "error for if" do
      script = """
      if false do
        i_will_never_run
      end
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     LiteralInCondition,
          message:  "Literal value found in conditional",
          line: 1,
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error for unless" do
      script = """
      unless [] do
        useless_unless
      end
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     LiteralInCondition,
          message:  "Literal value found in conditional",
          line: 1,
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error for case" do
      script = """
      case 0 do
        1 -> the_loneliest_number
        _ -> go_to_guy
      end
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     LiteralInCondition,
          message:  "Literal value found in conditional",
          line: 1,
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end
  end

  having "a piped in argument" do
    should "not error for if" do
      script = """
      something
      |> if do
        i_will_never_run
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error for unless" do
      script = """
      something
      |> unless do
        useless_unless
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error for case" do
      script = """
      something
      |> case do
      1 -> the_loneliest_number
      _ -> go_to_guy
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end
  end
end
