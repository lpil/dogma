defmodule Dogma.RulesTest do
  use ShouldI

  alias Dogma.Rules

  should "Return modules under Dogma.Rules" do
    for rule_name <- Rules.list do
      rule_name = to_string rule_name
      assert Regex.match?( ~r/\AElixir.Dogma.Rules./, rule_name )
    end
  end
end
