defmodule Dogma.Rule.NegatedIfUnlessTest do
  use ShouldI

  alias Dogma.Rule.NegatedIfUnless
  alias Dogma.Script
  alias Dogma.Error

  defp test(source) do
    source |> Script.parse!( "foo.ex" ) |> NegatedIfUnless.test
  end

  with "a non negated predicate" do
    should "not error with if" do
      errors = """
      if it_was_really_good do
        boast_about_your_weekend
      end
      """ |> test
      assert [] == errors
    end

    should "not error with unless" do
      errors = """
      unless youre_quite_full do
        have_another_slice_of_cake
      end
      """ |> test
      assert [] == errors
    end
  end


  with "a predicate negated with 'not'" do
    should "error with if" do
      errors = """
      if not that_great do
        make_the_best_of_it
      end
      """ |> test
      expected_errors = [
        %Error{
          message: "Favour unless over a negated if",
          line: 1,
          rule: NegatedIfUnless,
        }
      ]
      assert expected_errors == errors
    end

    should "error with unless" do
      errors = """
      unless not acceptable do
        find_something_better
      end
      """ |> test
      expected_errors = [
        %Error{
          message: "Favour if over a negated unless",
          line: 1,
          rule: NegatedIfUnless,
        }
      ]
      assert expected_errors == errors
    end
  end

  with "a predicate negated with '!'" do
    should "error with if" do
      errors = """
      if ! that_great do
        make_the_best_of_it
      end
      """ |> test
      expected_errors = [
        %Error{
          message: "Favour unless over a negated if",
          line: 1,
          rule: NegatedIfUnless,
        }
      ]
      assert expected_errors == errors
    end

    should "error with unless" do
      errors = """
      IO.puts "Hello, world!"
      unless ! acceptable do
        find_something_better
      end
      """ |> test
      expected_errors = [
        %Error{
          message: "Favour if over a negated unless",
          line: 2,
          rule: NegatedIfUnless,
        }
      ]
      assert expected_errors == errors
    end
  end
end
