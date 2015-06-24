defmodule Dogma.Rules.LiteralInConditionTest do
  use DogmaTest.Helper

  alias Dogma.Rules.LiteralInCondition
  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.parse( "foo.ex" ) |> LiteralInCondition.test
  end

  with "a variable/function argument" do
    with "if" do
      setup context do
        script = """
        if feeling_tired do
          have_an_early_night
        end
        """ |> test
        %{ script: script }
      end
      should_register_no_errors
    end

    with "unless" do
      setup context do
        script = """
        unless feeling_sleepy do
          a_little_dance
        end
        """ |> test
        %{ script: script }
      end
      should_register_no_errors
    end

    with "case" do
      setup context do
        script = """
        case status do
          :hyped -> run_like_the_wind
          _      -> dawdle
        end
        """ |> test
        %{ script: script }
      end
      should_register_no_errors
    end
  end


  with "a literal argument" do
    with "if" do
      setup context do
        script = """
        if false do
          i_will_never_run
        end
        """ |> test
        %{ script: script }
      end
      should_register_errors [
        %Error{
          rule:     LiteralInCondition,
          message:  "Literal value found in conditional",
          position: 1,
        }
      ]
    end

    with "unless" do
      setup context do
        script = """
        unless [] do
          useless_unless
        end
        """ |> test
        %{ script: script }
      end
      should_register_errors [
        %Error{
          rule:     LiteralInCondition,
          message:  "Literal value found in conditional",
          position: 1,
        }
      ]
    end

    with "case" do
      setup context do
        script = """
        case 0 do
          1 -> the_loneliest_number
          _ -> go_to_guy
        end
        """ |> test
        %{ script: script }
      end
      should_register_errors [
        %Error{
          rule:     LiteralInCondition,
          message:  "Literal value found in conditional",
          position: 1,
        }
      ]
    end
  end

  with "a piped in argument" do
    with "if" do
      setup context do
        script = """
        something
        |> if do
          i_will_never_run
        end
        """ |> test
        %{ script: script }
      end
      should_register_no_errors
    end

    with "unless" do
      setup context do
        script = """
        something
        |> unless do
          useless_unless
        end
        """ |> test
        %{ script: script }
      end
      should_register_no_errors
    end

    with "case" do
      setup context do
        script = """
        something
        |> case do
          1 -> the_loneliest_number
          _ -> go_to_guy
        end
        """ |> test
        %{ script: script }
      end
      should_register_no_errors
    end
  end
end
