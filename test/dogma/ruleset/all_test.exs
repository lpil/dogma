defmodule Dogma.RuleSet.AllTest do
  use ShouldI

  alias Dogma.RuleSet.All

  with ".list" do

    should "return tuples with the first element being a Module name" do
      for rule <- All.list do
        rule_name = case rule do
          {module, _} -> module |> to_string
          {module}    -> module |> to_string
        end
        assert Regex.match?( ~r/^[A-Z][A-Za-z\.]+$/, rule_name )
      end
    end

    should "return a module for each file in lib/dogma/rules/" do
      rules_files = Path.wildcard("lib/dogma/rules/*.ex")
      assert All.list |> length == rules_files |> length
    end

    should "contain LiteralInCondition" do
      assert Enum.member?(All.list, {LiteralInCondition})
    end

  end
end
