defmodule Dogma.Rules.UnlessElseTest do
  use DogmaTest.Helper

  alias Dogma.Rules.UnlessElse
  alias Dogma.Script
  alias Dogma.Error

  with "unless with else" do
    setup context do
      script = """
      unless feeling_sleepy? do
        a_little_dance
      else
        this_is_not_ok!
      end
      """ |> Script.parse( "foo.ex" )
      %{
        errors: UnlessElse.test( script )
      }
    end

    should_register_errors [
      %Error{
        message: "Favour if over unless with else",
        line: 1,
        rule: UnlessElse,
      }
    ]
  end


  with "unless without else" do
    setup context do
      script = """
      unless feeling_sleepy? do
        a_little_dance
      end
      """ |> Script.parse( "foo.ex" )
      %{
        errors: UnlessElse.test( script )
      }
    end

    should_register_no_errors
  end


  with "if with else" do
    setup context do
      script = """
      if a_good_test? do
        jump_for_joy
      else
        be_very_sad( until: :fixed )
      end
      """ |> Script.parse( "foo.ex" )
      %{
        errors: UnlessElse.test( script )
      }
    end
    should_register_no_errors
  end
end
