defmodule Dogma.Documentation.ReportersTest do
  use ShouldI

  alias Dogma.Documentation.ReportersList

  should "have an up to date docs/reporters.md file" do
    expected = ReportersList.reporters_doc
    actual = File.read!("docs/reporters.md")
    assert actual == expected, """
    docs/reporters.md is out of date.

    Run `mix run scripts/generate_documentation.exs` in order to regenerate
    the documentation.
    """
  end
end
