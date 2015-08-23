defmodule Dogma.Rules.NegatedIfUnlessTest do
  use DogmaTest.Helper

  alias Dogma.Rules.NegatedIfUnless
  alias Dogma.Script
  alias Dogma.Error

  with "a non negated predicate" do
    with "if" do
      setup context do
        script = """
        if it_was_really_good do
          boast_about_your_weekend
        end
        """ |> Script.parse( "foo.ex" )
        %{
          errors: NegatedIfUnless.test( script )
        }
      end
      should_register_no_errors
    end

    with "unless" do
      setup context do
        script = """
        unless youre_quite_full do
          have_another_slice_of_cake
        end
        """ |> Script.parse( "foo.ex" )
        %{
          errors: NegatedIfUnless.test( script )
        }
      end
      should_register_no_errors
    end
  end


  with "a predicate negated with 'not'" do
    with "if" do
      setup context do
        script = """
        if not that_great do
          make_the_best_of_it
        end
        """ |> Script.parse( "foo.ex" )
        %{
          errors: NegatedIfUnless.test( script )
        }
      end
      should_register_errors [
        %Error{
          message: "Favour unless over a negated if",
          line: 1,
          rule: NegatedIfUnless,
        }
      ]
    end

    with "unless" do
      setup context do
        script = """
        unless not acceptable do
          find_something_better
        end
        """ |> Script.parse( "foo.ex" )
        %{
          errors: NegatedIfUnless.test( script )
        }
      end
      should_register_errors [
        %Error{
          message: "Favour if over a negated unless",
          line: 1,
          rule: NegatedIfUnless,
        }
      ]
    end
  end

  with "a predicate negated with '!'" do
    with "if" do
      setup context do
        script = """
        if ! that_great do
          make_the_best_of_it
        end
        """ |> Script.parse( "foo.ex" )
        %{
          errors: NegatedIfUnless.test( script )
        }
      end
      should_register_errors [
        %Error{
          message: "Favour unless over a negated if",
          line: 1,
          rule: NegatedIfUnless,
        }
      ]
    end

    with "unless" do
      setup context do
        script = """
        IO.puts "Hello, world!"
        unless ! acceptable do
          find_something_better
        end
        """ |> Script.parse( "foo.ex" )
        %{
          errors: NegatedIfUnless.test( script )
        }
      end
      should_register_errors [
        %Error{
          message: "Favour if over a negated unless",
          line: 2,
          rule: NegatedIfUnless,
        }
      ]
    end
  end
end
