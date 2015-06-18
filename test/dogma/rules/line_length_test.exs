defmodule Dogma.Rules.LineLengthTest do
  use ShouldI

  alias Dogma.Rules.LineLength

  with "LineLength.line_too_long?" do
    should "be false for short lines" do
      line = build_line(79)
      refute LineLength.line_too_long?( line )
    end

    should "be true for long lines" do
      line = build_line(80)
      assert LineLength.line_too_long?( line )
    end
  end

  def build_line(length) do
    1..length
    |> Enum.reduce("", fn(_, acc) -> acc <> "x" end )
  end
end
