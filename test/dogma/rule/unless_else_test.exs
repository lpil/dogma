defmodule Dogma.Rule.UnlessElseTest do
  use ShouldI

  alias Dogma.Rule.UnlessElse
  alias Dogma.Script
  alias Dogma.Error

  defp lint(source) do
    source |> Script.parse!( "foo.ex" ) |> UnlessElse.test
  end


  should "not error when an unless does not have an else block" do
    errors = """
    unless feeling_sleepy? do
      a_little_dance
    end
    """ |> lint
    assert [] == errors
  end

  should "error when an unless has an else block" do
    errors = """
    unless feeling_sleepy? do
      a_little_dance
    else
      this_is_not_ok!
    end
    """ |> lint
    expected_errors = [
      %Error{
        message: "Favour if over unless with else",
        line: 1,
        rule: UnlessElse,
      }
    ]
    assert expected_errors == errors
  end

  should "not error when an if has an else block" do
    errors = """
    if a_good_test? do
      jump_for_joy
    else
      be_very_sad( until: :fixed )
    end
    """ |> lint
    assert [] == errors
  end
end
