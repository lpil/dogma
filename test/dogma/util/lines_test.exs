defmodule Dogma.Util.LinesTest do
  use ShouldI

  alias Dogma.Util.Lines

  should "split a string into lines" do
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
