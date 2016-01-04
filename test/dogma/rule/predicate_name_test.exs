defmodule Dogma.Rule.PredicateNameTest do
  use RuleCase, for: PredicateName

  should "not error for predicates without the `is_` prefix" do
    script = """
    def nice?(arg) do
      true
    end
    defp is_nice() do
      true
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error for predicates with the `is_` prefix" do
    script = """
    def is_naughty?(arg) do
      true
    end
    defp is_bad?() do
      true
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule: PredicateName,
        message: "Favour `bad?` over `is_bad?`",
        line: 4,
      },
      %Error{
        rule: PredicateName,
        message: "Favour `naughty?` over `is_naughty?`",
        line: 1,
      },
    ]
    assert expected_errors == Rule.test( @rule, script )
  end
end
