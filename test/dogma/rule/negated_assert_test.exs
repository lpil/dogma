defmodule Dogma.Rule.NegatedAssertTest do
  use RuleCase, for: NegatedAssert

  having "assert" do
    should "not error without negation" do
      script = """
      assert foo
      assert foo, "ok"
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "error when negated with !" do
      script = """
      assert ! foo
      assert ! foo, "not ok"
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          message: "Favour refute over a negated assert",
          line: 2,
          rule: NegatedAssert,
        },
        %Error{
          message: "Favour refute over a negated assert",
          line: 1,
          rule: NegatedAssert,
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error when negated with not" do
      script = """
      assert not foo
      assert not foo, "not ok"
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          message: "Favour refute over a negated assert",
          line: 2,
          rule: NegatedAssert,
        },
        %Error{
          message: "Favour refute over a negated assert",
          line: 1,
          rule: NegatedAssert,
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end
  end


  having "refute" do
    should "not error without negation" do
      script = """
      refute foo
      """ |> Script.parse!("")
      assert [] == Rule.test( @rule, script )
    end

    should "error when negated with !" do
      script = """
      refute ! foo
      refute ! foo, "not ok"
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          message: "Favour assert over a negated refute",
          line: 2,
          rule: NegatedAssert,
        },
        %Error{
          message: "Favour assert over a negated refute",
          line: 1,
          rule: NegatedAssert,
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error when negated with not" do
      script = """
      refute not foo
      refute not foo, "not ok"
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          message: "Favour assert over a negated refute",
          line: 2,
          rule: NegatedAssert,
        },
        %Error{
          message: "Favour assert over a negated refute",
          line: 1,
          rule: NegatedAssert,
        }
      ]
      assert expected_errors == Rule.test( @rule, script )
    end
  end
end
