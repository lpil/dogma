defmodule Dogma.Documentation.RuleListTest do
  use ExUnit.Case, async: true

  alias Dogma.Documentation.RuleList

  test "have an up to date docs/rules.md file" do
    expected = RuleList.rules_doc
    actual = File.read! "docs/rules.md"
    assert actual == expected, """
    docs/rules.md is out of date.

    Run `mix run scripts/generate_documentation.exs` in order to regenerate
    the documentation.
    """
  end
end
