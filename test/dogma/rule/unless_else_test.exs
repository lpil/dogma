defmodule Dogma.Rule.UnlessElseTest do
  use RuleCase, for: UnlessElse

  should "not error when an unless does not have an else block" do
    script = """
    unless feeling_sleepy? do
      a_little_dance
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error when an unless has an else block" do
    script = """
    unless feeling_sleepy? do
      a_little_dance
    else
      this_is_not_ok!
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        message: "Favour if over unless with else",
        line: 1,
        rule: UnlessElse,
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  should "not error when an if has an else block" do
    script = """
    if a_good_test? do
      jump_for_joy
    else
      be_very_sad( until: :fixed )
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end
end
