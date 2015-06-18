defmodule Dogma.Rules.LineLength do
  alias Dogma.Script

  def test(script) do
    script
  end

  def line_too_long?(line) do
    String.length( line ) > 79
  end
end
