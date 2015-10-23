defmodule Dogma.ConfigTest do
  use ShouldI, async: false
  use TemporaryEnv

  alias Dogma.Config

  with "rules" do
    should "take the rule set from the application env" do
      dummy_set = Module.concat [__MODULE__, RuleSet]
      TemporaryEnv.set( :dogma, rule_set: dummy_set ) do
        assert Config.build.rules == %{ hello: "world" }
      end
    end

    should "default to Dogma.RuleSet.All" do
      assert nil == Application.get_env( :dogma, :rule_set )
      assert Dogma.RuleSet.All.rules == Config.build.rules
    end
  end

  with "exclude" do
    should "take the exclude from the application env" do
      TemporaryEnv.set( :dogma, exclude: [1, 2, 3] ) do
        assert Config.build.exclude == [1, 2, 3]
      end
    end

    should "default to []" do
      assert nil == Application.get_env( :dogma, :rule_set )
      assert [] == Config.build.exclude
    end
  end

  defmodule RuleSet do
    def rules do
      %{ hello: "world" }
    end
  end
end
