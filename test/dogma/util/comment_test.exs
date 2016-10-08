defmodule Dogma.Util.CommentsTest do
  use ExUnit.Case, async: true

  alias Dogma.Util.Lines
  alias Dogma.Util.ScriptSigils
  alias Dogma.Util.ScriptStrings
  alias Dogma.Util.Comment

  def run(source) do
    source
    |> ScriptSigils.strip
    |> ScriptStrings.strip
    |> Lines.get
    |> Comment.get_all
  end

  test "extract comments" do
    comments = """
    # Very useful.
    defmodule Foo do
      #this is rad.
      def magic do
        1 + 1
      end#    # Thuper.
    end
    """ |> run
    expected = [
      %Comment{ line: 1, content: " Very useful." },
      %Comment{ line: 3, content: "this is rad." },
      %Comment{ line: 6, content: "    # Thuper." },
    ]
    assert comments == expected
  end

  test "not mistake a # in a sigil for a comment" do
    comments = """
    ~r/#/
    ~S" # "
    ~w( # # # )
    """ |> run
    assert comments == []
  end
end
