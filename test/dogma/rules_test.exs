defmodule Dogma.RulesTest do
  use ShouldI

  alias Dogma.Rules

  with ".list" do

    should "return tuples with the first element being a Dogma.Rule" do
      for rule <- Rules.list do
         rule_name = case rule do
           {module, _} -> module |> to_string
           {module}    -> module |> to_string
         end
        assert Regex.match?( ~r/\AElixir.Dogma.Rules./, rule_name )
      end
    end

    should "return a module for each file in lib/dogma/rules/" do
      rules_files = Path.wildcard("lib/dogma/rules/*.ex")
      assert Rules.list |> length == rules_files |> length
    end

    should "contain Dogma.Rules.LiteralInCondition" do
      assert Enum.member?(Rules.list, {Dogma.Rules.LiteralInCondition})
    end

  end
end
