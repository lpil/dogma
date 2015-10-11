defmodule Dogma.ConfigTest do
  use ShouldI, async: false

  alias Dogma.Config

  with "rules" do
    should "take the rule set from the application env" do
      dummy_set = Module.concat [__MODULE__, RuleSet]
      Application.put_env( :dogma, :rule_set, dummy_set )
      assert Config.build.rules == %{ hello: "world" }
      Application.delete_env( :dogma, :rule_set )
    end

    should "default to Dogma.RuleSet.All" do
      assert nil == Application.get_env( :dogma, :rule_set )
      assert Dogma.RuleSet.All.rules == Config.build.rules
    end
  end

  defmodule RuleSet do
    def rules do
      %{ hello: "world" }
    end
  end
end
