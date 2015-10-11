defmodule Dogma.RulesTest do
  use ExUnit.Case
  import Mock
  alias Dogma.Rules
  alias Dogma.Script

  @formater_for_testing Dogma.Formatter.Simple

  test "returns empty list when given no scripts" do
    result = Rules.test([], @formater_for_testing)
    assert result == []
  end

  test "Updates a script with the errors from rules" do
    with_mock Dogma.RuleSet.All, [rules: fn() -> [{FakeRule}] end] do
      single_script = %Script{}
      expected_script_after_run = %Script{errors: [:always_fake_error]}

      result = Rules.test([single_script], @formater_for_testing)

      assert result == [expected_script_after_run]
    end
  end

end

defmodule Dogma.Rule.FakeRule do
  def test(_script, _config = [] \\ []) do
    [:always_fake_error]
  end
end
