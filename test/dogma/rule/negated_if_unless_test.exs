defmodule Dogma.Rule.NegatedIfUnlessTest do
  use RuleCase, for: NegatedIfUnless

  having "a non negated predicate" do
    should "not error with if" do
      script = """
      if it_was_really_good do
        boast_about_your_weekend
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "not error with unless" do
      script = """
      unless youre_quite_full do
        have_another_slice_of_cake
      end
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end
  end


  having "a predicate negated with 'not'" do
    should "error with if" do
      script = """
      if not that_great do
        make_the_best_of_it
      end
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          message: "Favour unless over a negated if",
          line: 1,
          rule: NegatedIfUnless,
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error with unless" do
      script = """
      unless not acceptable do
        find_something_better
      end
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          message: "Favour if over a negated unless",
          line: 1,
          rule: NegatedIfUnless,
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end
  end

  having "a predicate negated with '!'" do
    should "error with if" do
      script = """
      if ! that_great do
        make_the_best_of_it
      end
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          message: "Favour unless over a negated if",
          line: 1,
          rule: NegatedIfUnless,
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error with unless" do
      script = """
      IO.puts "Hello, world!"
      unless ! acceptable do
        find_something_better
      end
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          message: "Favour if over a negated unless",
          line: 2,
          rule: NegatedIfUnless,
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end
  end
end
