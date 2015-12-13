defmodule Dogma.RuleBuilderTest do
  use ShouldI

  use Dogma.RuleBuilder
  alias Dogma.Rule

  defrule MagicTestRule, [awesome: :yes] do
    def test(_rule, script) do
      script <> " ok!"
    end
  end

  should "create a struct for the rule" do
    %MagicTestRule{}
  end

  should "set :enabled to true" do
    assert true = %MagicTestRule{}.enabled
  end

  should "include the args in the struct" do
    assert %MagicTestRule{}.awesome == :yes
  end

  should "implement the Dogma.Rule protocol" do
    assert Rule.test(%MagicTestRule{}, "ok?") == "ok? ok!"
  end
end
