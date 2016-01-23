defmodule Dogma.RuleBuilderTest do
  use ExUnit.Case

  use Dogma.RuleBuilder

  alias Dogma.Rule
  alias Dogma.Script

  defrule MagicTestRule, [awesome: :yes] do
    @moduledoc false
    def test(_rule, _script) do
      :ok
    end
  end

  test "it creates a struct for the rule" do
    %MagicTestRule{}
  end

  test "it sets :enabled to true" do
    assert true = %MagicTestRule{}.enabled
  end

  test "it includes the args in the struct" do
    assert %MagicTestRule{}.awesome == :yes
  end

  test "implements the Dogma.Rule protocol" do
    script = "1 + 1" |> Script.parse!("")
    result = Rule.test( %MagicTestRule{}, script )
    assert result == :ok
  end


  defrule ConfiglessTest do
    @moduledoc false
    def test(_rule, _script) do
      :ok
    end
  end

  test "can accept no option list" do
    %ConfiglessTest{}
  end

  test "still sets :enabled to true with no options" do
    assert true = %ConfiglessTest{}.enabled
  end
end
