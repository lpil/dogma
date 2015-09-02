defmodule Dogma.Documentation.FormattersTest do
  use ShouldI

  alias Dogma.Documentation.FormattersList

  should "have an up to date docs/formatters.md file" do
    expected = FormattersList.formatters_doc
    actual = File.read!("docs/formatters.md")
    assert actual == expected, """
    docs/formatters.md is out of date.

    Run `mix run scripts/generate_documentation.exs` in order to regenerate
    the documentation.
    """
  end
end
