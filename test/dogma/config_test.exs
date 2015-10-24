defmodule Dogma.ConfigTest do
  use ShouldI, async: false
  use TemporaryEnv

  alias Dogma.Config

  @dummy_set Module.concat [__MODULE__, RuleSet]

  with "rules" do
    should "take the rule set from the application env" do
      TemporaryEnv.set( :dogma, rule_set: @dummy_set ) do
        assert Config.build.rules == %{ foo: [], bar: [] }
      end
    end

    should "default to Dogma.RuleSet.All" do
      TemporaryEnv.delete( :dogma, :rule_set ) do
        assert Dogma.RuleSet.All.rules == Config.build.rules
      end
    end

    should "not include rules overriden with a falsey value" do
      TemporaryEnv.set( :dogma, rule_set: @dummy_set ) do
        TemporaryEnv.set( :dogma, overrides: %{ foo: false } ) do
          assert Config.build.rules == %{ bar: [] }
        end
      end
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
      %{
        foo: [],
        bar: [],
      }
    end
  end
end
