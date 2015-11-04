defmodule Dogma.Util.ScriptStringsTest do
  use ShouldI

  alias Dogma.Util.ScriptStrings

  with "blank/1" do
    should "no-op with empty scripts" do
      processed = "" |> ScriptStrings.blank
      assert processed == ""
    end

    should "no-op with stringless scripts" do
      script = """
      defmodule Hello do
        def World do
          :dennis_rocks
        end
      end
      """
      processed = script |> ScriptStrings.blank
      assert processed == script
    end

    should "no-op with double quote character (?\")" do
      script = """
      defmodule Hello do
        def World do
          [?", :dennis_rocks]
        end
      end
      """
      processed = script |> ScriptStrings.blank
      assert processed == script
    end

    should "strip contents from s sigil" do
      script = """
      defmodule Sneaky do
        def String do
          ~s(Hey, look, this is a string!)
        end
      end
      """
      desired = """
      defmodule Sneaky do
        def String do
          ~s()
        end
      end
      """
      assert desired == script |> ScriptStrings.blank
    end

    should "strip contents from S sigil" do
      script = """
      defmodule Sneaky do
        def String do
          ~S(Hey, look, this is ALSO a string!)
        end
      end
      """
      desired = """
      defmodule Sneaky do
        def String do
          ~S()
        end
      end
      """
      assert desired == script |> ScriptStrings.blank
    end

    should "strip contents from strings, preserving newlines" do
      processed = """
      defmodule Newliney do
        def string(x) do
          x <> "Hello,
world!"
        end
      end
      """ |> ScriptStrings.blank
      desired = """
      defmodule Newliney do
        def string(x) do
          x <> "
"
        end
      end
      """
      assert processed == desired
    end

    should "strip contents from docstrings, preserving newlines" do
      processed = [
        ~s(defmodule Docky do),
        ~s[  def string(x) do],
        ~s(    """),
        ~s(    Hello,),
        ~s(    world!),
        ~s(    """),
        ~s(  end),
        ~s(end),
      ] |> Enum.join |> ScriptStrings.blank
      desired = [
        ~s(defmodule Docky do),
        ~s[  def string(x) do],
        ~s(    """),
        ~s(),
        ~s(),
        ~s("""),
        ~s(  end),
        ~s(end),
      ] |> Enum.join
      assert processed == desired
    end

    should "strip an escaped backslash from docstrings" do
      processed = [
        ~s(defmodule Slashes do),
        ~s[  def backslash() do],
        ~s(    """),
        ~s(      \\\\),
        ~s(    """),
        ~s(  end),
        ~s(end),
      ] |> Enum.join |> ScriptStrings.blank
      desired = [
        ~s(defmodule Slashes do),
        ~s[  def backslash() do],
        ~s(    """),
        ~s(),
        ~s("""),
        ~s(  end),
        ~s(end),
      ] |> Enum.join
      assert processed == desired
    end

    should "strip an escaped doublequote from docstrings" do
      processed = [
        ~s(defmodule Quotes do),
        ~s[  def doublequote() do],
        ~s(    """),
        ~s(      \\\"),
        ~s(    """),
        ~s(  end),
        ~s(end),
      ] |> Enum.join |> ScriptStrings.blank
      desired = [
        ~s(defmodule Quotes do),
        ~s[  def doublequote() do],
        ~s(    """),
        ~s(),
        ~s("""),
        ~s(  end),
        ~s(end),
      ] |> Enum.join
      assert processed == desired
    end

    should "handle quotes in strings" do
      processed = ~S"""
      defmodule Boardroom do
        def say(x) do
          "You just said \"merger\"! Shots!"
        end
      end
      """ |> ScriptStrings.blank
      desired = """
      defmodule Boardroom do
        def say(x) do
          ""
        end
      end
      """
      assert processed == desired
    end

    should "handle quotes preceeded by escaped slashes in strings" do
      processed = ~S"""
      defmodule Identifier do
        def say(x) do
          "This here is a slash -> \\"
        end
      end
      """ |> ScriptStrings.blank
      desired = """
      defmodule Identifier do
        def say(x) do
          ""
        end
      end
      """
      assert processed == desired
    end

    should "handle quotes in doc strings" do
      processed = [
        ~s(defmodule Doc do),
        ~s[  def string(x) do],
        ~s(    """),
        ~s(    Check out this quote -> "),
        ~s(    """),
        ~s(  end),
        ~s(end),
      ] |> Enum.join |> ScriptStrings.blank
      desired = [
        ~s(defmodule Doc do),
        ~s[  def string(x) do],
        ~s(    """),
        ~s(),
        ~s("""),
        ~s(  end),
        ~s(end),
      ] |> Enum.join
      assert processed == desired
    end
  end
end
