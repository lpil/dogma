defmodule Dogma.Util.CommentsTest do
  use ShouldI

  alias Dogma.Util.Lines
  alias Dogma.Util.ScriptStrings
  alias Dogma.Util.Comment

  def run(source) do
    source
    |> ScriptStrings.blank
    |> Lines.get
    |> Comment.get_all
  end

  should "extract comments" do
    comments = """
    # Very useful.
    defmodule Foo do
      # this is rad.
      def magic do
        1 + 1
      end
    end
    """ |> run
    expected = [
      %Comment{ line: 1, content: "Very useful." },
      %Comment{ line: 3, content: "this is rad." },
    ]
    assert comments == expected
  end

  should "extract comments with no spaces after the #" do
    comments = """
    #Very useful.
    defmodule Foo do
      #this is rad.
      def magic do
        1 + 1
      end
    end
    """ |> run
    expected = [
      %Comment{ line: 1, content: "Very useful." },
      %Comment{ line: 3, content: "this is rad." },
    ]
    assert comments == expected
  end
end
