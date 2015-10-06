defmodule Dogma.Rule.NegatedAssertTest do
  use ShouldI

  alias Dogma.Rule.NegatedAssert
  alias Dogma.Script
  alias Dogma.Error

  defp lint(source) do
    source |> Script.parse!( "foo.ex" ) |> NegatedAssert.test
  end

  with "assert" do
    should "not error without negation" do
      errors = """
      assert foo
      assert foo, "ok"
      """ |> lint
      assert [] == errors
    end

    should "error when negated with !" do
      errors = """
      assert ! foo
      assert ! foo, "not ok"
      """ |> lint
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
      assert expected_errors == errors
    end

    should "error when negated with not" do
      errors = """
      assert not foo
      assert not foo, "not ok"
      """ |> lint
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
      assert expected_errors == errors
    end
  end


  with "refute" do
    should "not error without negation" do
      errors = """
      refute foo
      """ |> lint
      assert [] == errors
    end

    should "error when negated with !" do
      errors = """
      refute ! foo
      refute ! foo, "not ok"
      """ |> lint
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
      assert expected_errors == errors
    end

    should "error when negated with not" do
      errors = """
      refute not foo
      refute not foo, "not ok"
      """ |> lint
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
      assert expected_errors == errors
    end
  end
end
