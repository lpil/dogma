defmodule Dogma.Rule.MatchInConditionTest do
  use RuleCase, for: MatchInCondition

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
  end

  having "a literal argument" do
    should "not error for if" do
      script = """
      if false do
        i_will_never_run
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error for unless" do
      script = """
      unless [] do
        useless_unless
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end
  end

  having "a piped in argument" do
    should "not error for if" do
      script = """
      something
      |> if do
        something_else
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error for unless" do
      script = """
      something
      |> unless do
        something_else
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end
  end

  having "a comparison argument" do
    should "not error for if" do
      script = """
      if x ==  y do z end
      if x === y do z end
      if x !=  y do z end
      if x !== y do z end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error for unless" do
      script = """
      unless x ==  y do z end
      unless x === y do z end
      unless x !=  y do z end
      unless x !== y do z end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end
  end

  having "match argument" do
    should "error for if" do
      script = """
      if x         = y do z end
      if {x1, x2}  = y do z end
      if [x, _, _] = y do z end
      if %{ x: x } = y do z end
      """ |> Script.parse!("")
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
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error for unless" do
      script = """
      unless x         = y do z end
      unless {x1, x2}  = y do z end
      unless [x, _, _] = y do z end
      unless %{ x: x } = y do z end
      """ |> Script.parse!("")
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
      assert expected_errors == Rule.test( @rule, script )
    end
  end
end
