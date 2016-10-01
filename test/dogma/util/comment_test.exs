defmodule Dogma.Util.CommentsTest do
  use ShouldI

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

  should "extract comments" do
    comments = """
    ### Comments for Foo
    # Very useful.
    defmodule Foo do
      #this is rad.
      def magic do
        1 + 1
      end#    # Thuper.
    end
    """ |> run
    expected = [
      %Comment{ line: 1, content: " Comments for Foo" },
      %Comment{ line: 2, content: " Very useful." },
      %Comment{ line: 4, content: "this is rad." },
      %Comment{ line: 7, content: "    # Thuper." },
    ]
    assert comments == expected
  end

  should "not mistake a # in a sigil for a comment" do
    comments = """
    ~r/#/
    ~S" # "
    ~w( # # # )
    """ |> run
    assert comments == []
  end
end
