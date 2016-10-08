defmodule Dogma.Util.LinesTest do
  use ExUnit.Case, async: true

  alias Dogma.Util.Lines

  test "split a string into lines" do
    result = """
    Hello,
    world!
    """ |> Lines.get
    expected = [
      {1, "Hello,"},
      {2, "world!"},
    ]
    assert result == expected
  end
end
