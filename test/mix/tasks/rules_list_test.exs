defmodule Mix.Tasks.Dogma.RulesListTest do
  use ShouldI

  alias Mix.Tasks.Dogma.RulesList

  should "have an up to date docs/rules.md file" do
    expected = RulesList.rules_doc
    actual = File.read! "docs/rules.md"
    assert actual == expected, """
    docs/rules.md is out of date.

    Run `mix dogma.rules_list` in order to regenerate this documentation.
    """
  end
end
