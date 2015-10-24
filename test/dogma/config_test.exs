defmodule Dogma.ConfigTest do
  use ShouldI, async: false
  use TemporaryEnv

  alias Dogma.Config

  @dummy_set Module.concat [__MODULE__, RuleSet]

  with "rules" do
    should "take the rule set from the application env" do
      TemporaryEnv.set( :dogma, rule_set: @dummy_set ) do
        TemporaryEnv.delete( :dogma, :override ) do
          assert Config.build.rules == %{ Foo => [], Bar => [] }
        end
      end
    end

    should "default to Dogma.RuleSet.All" do
      TemporaryEnv.delete( :dogma, :rule_set ) do
        TemporaryEnv.delete( :dogma, :override ) do
          assert Dogma.RuleSet.All.rules == Config.build.rules
        end
      end
    end

    should "not include rules overridden with a falsey value" do
      TemporaryEnv.set( :dogma, rule_set: @dummy_set ) do
        TemporaryEnv.set( :dogma, override: %{ Foo => false } ) do
          assert Config.build.rules == %{ Bar => [] }
        end
      end
    end

    should "enable rule arguments to be overridden through application env" do
      TemporaryEnv.set( :dogma, rule_set: @dummy_set ) do
        TemporaryEnv.set( :dogma, override: %{ Foo => [answer: 42] } ) do
          assert Config.build.rules == %{ Foo => [answer: 42], Bar => [] }
        end
      end
    end

    should "enable rules to be added through application env" do
      TemporaryEnv.set( :dogma, rule_set: @dummy_set ) do
        TemporaryEnv.set( :dogma, override: %{ Baz => [funky: true] } ) do
          assert Config.build.rules == %{
            Foo => [],
            Bar => [],
            Baz => [funky: true],
          }
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
        Foo => [],
        Bar => [],
      }
    end
  end
end
