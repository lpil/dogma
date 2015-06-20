defmodule Dogma.Rules.UnlessElseTest do
  use ShouldI

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
        script: UnlessElse.test( script )
      }
    end

    should "assign an error", context do
      error = %Error{
        message: "Favour if over unless with else",
        position: 1,
        rule: UnlessElse,
      }
      assert [error] == context.script.errors
    end
  end


  with "unless without else" do
    setup context do
      script = """
      unless feeling_sleepy? do
        a_little_dance
      end
      """ |> Script.parse( "foo.ex" )
      %{
        script: UnlessElse.test( script )
      }
    end

    should "not assign an error", context do
      assert [] == context.script.errors
    end
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
        script: UnlessElse.test( script )
      }
    end

    should "not assign an error", context do
      assert [] == context.script.errors
    end
  end
end
