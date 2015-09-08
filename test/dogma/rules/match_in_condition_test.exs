defmodule Dogma.Rules.MatchInConditionTest do
  use ShouldI

  alias Dogma.Rules.MatchInCondition
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse!( "foo.ex" ) |> MatchInCondition.test
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
  end

  with "a literal argument" do
    should "not error for if" do
      errors = """
      if false do
        i_will_never_run
      end
      """ |> test
      assert [] == errors
    end

    should "not error for unless" do
      errors = """
      unless [] do
        useless_unless
      end
      """ |> test
      assert [] == errors
    end
  end

  with "a piped in argument" do
    should "not error for if" do
      errors = """
      something
      |> if do
        something_else
      end
      """ |> test
      assert [] == errors
    end

    should "not error for unless" do
      errors = """
      something
      |> unless do
        something_else
      end
      """ |> test
      assert [] == errors
    end
  end

  with "a comparison argument" do
    should "not error for if" do
      errors = """
      if x ==  y do z end
      if x === y do z end
      if x !=  y do z end
      if x !== y do z end
      """ |> test
      assert [] == errors
    end

    should "not error for unless" do
      errors = """
      unless x ==  y do z end
      unless x === y do z end
      unless x !=  y do z end
      unless x !== y do z end
      """ |> test
      assert [] == errors
    end
  end

  with "match argument" do
    should "error for if" do
      errors = """
      if x         = y do z end
      if {x1, x2}  = y do z end
      if [x, _, _] = y do z end
      if %{ x: x } = y do z end
      """ |> test
      expected_errors = [
        %Error{
          rule:    MatchInCondition,
          message: "Do not use = in if or unless.",
          line: 4,
        },
        %Error{
          rule:    MatchInCondition,
          message: "Do not use = in if or unless.",
          line: 3,
        },
        %Error{
          rule:    MatchInCondition,
          message: "Do not use = in if or unless.",
          line: 2,
        },
        %Error{
          rule:    MatchInCondition,
          message: "Do not use = in if or unless.",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end

    should "error for unless" do
      errors = """
      unless x         = y do z end
      unless {x1, x2}  = y do z end
      unless [x, _, _] = y do z end
      unless %{ x: x } = y do z end
      """ |> test
      expected_errors = [
        %Error{
          rule:    MatchInCondition,
          message: "Do not use = in if or unless.",
          line: 4,
        },
        %Error{
          rule:    MatchInCondition,
          message: "Do not use = in if or unless.",
          line: 3,
        },
        %Error{
          rule:    MatchInCondition,
          message: "Do not use = in if or unless.",
          line: 2,
        },
        %Error{
          rule:    MatchInCondition,
          message: "Do not use = in if or unless.",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end
  end
end
