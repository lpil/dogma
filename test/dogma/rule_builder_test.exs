defmodule Dogma.RuleBuilderTest do
  use ShouldI

  use Dogma.RuleBuilder

  defrule MagicTestRule, [awesome: :yes] do
    @moduledoc false
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


  having "no options for the rule" do
    defrule ConfiglessTest do
      @moduledoc false
      def test(_rule, script) do
        script <> " Also good!"
      end
    end

    should "create a struct for the rule" do
      %ConfiglessTest{}
    end

    should "set :enabled to true" do
      assert true = %ConfiglessTest{}.enabled
    end
  end
end
