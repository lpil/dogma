defmodule Dogma.Documentation.RuleListTest do
  use ShouldI

  alias Dogma.Documentation.RuleList

  should "have an up to date docs/rules.md file" do
    expected = RuleList.rules_doc
    actual = File.read! "docs/rules.md"
    assert actual == expected, """
    docs/rules.md is out of date.

    Run `mix run script/generate_documentation.ex` in order to regenerate
    the documentation.
    """
  end
end
