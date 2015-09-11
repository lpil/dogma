defmodule Dogma.Rule.LiteralInConditionTest do
  use ShouldI

  alias Dogma.Rule.LiteralInCondition
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse!( "foo.ex" ) |> LiteralInCondition.test
  end

  with "a variable/function argument" do
    should "not error for if" do
      errors = """
      if feeling_tired do
        have_an_early_night
      end
      """ |> test
      assert [] == errors
    end

    should "not error for unless" do
      errors = """
      unless feeling_sleepy do
        a_little_dance
      end
      """ |> test
      assert [] == errors
    end

    should "not error for case" do
      errors = """
      case status do
        :hyped -> run_like_the_wind
        _      -> dawdle
      end
      """ |> test
      assert [] == errors
    end
  end


  with "a literal argument" do
    should "error for if" do
      errors = """
      if false do
        i_will_never_run
      end
      """ |> test
      expected_errors = [
        %Error{
          rule:     LiteralInCondition,
          message:  "Literal value found in conditional",
          line: 1,
        }
      ]
      assert expected_errors == errors
    end

    should "error for unless" do
      errors = """
      unless [] do
        useless_unless
      end
      """ |> test
      expected_errors = [
        %Error{
          rule:     LiteralInCondition,
          message:  "Literal value found in conditional",
          line: 1,
        }
      ]
      assert expected_errors == errors
    end

    should "error for case" do
      errors = """
      case 0 do
        1 -> the_loneliest_number
        _ -> go_to_guy
      end
      """ |> test
      expected_errors = [
        %Error{
          rule:     LiteralInCondition,
          message:  "Literal value found in conditional",
          line: 1,
        }
      ]
      assert expected_errors == errors
    end
  end

  with "a piped in argument" do
    should "not error for if" do
      errors = """
      something
      |> if do
        i_will_never_run
      end
      """ |> test
      assert [] == errors
    end

    should "not error for unless" do
      errors = """
      something
      |> unless do
        useless_unless
      end
      """ |> test
      assert [] == errors
    end

    should "not error for case" do
      errors = """
      something
      |> case do
      1 -> the_loneliest_number
      _ -> go_to_guy
      end
      """ |> test
      assert [] == errors
    end
  end
end
