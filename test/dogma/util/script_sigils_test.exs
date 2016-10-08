defmodule Dogma.Util.ScriptSigilsTest do
  use ExUnit.Case, async: true

  alias Dogma.Util.ScriptSigils

  describe "strip/1" do
    test "no-op with empty scripts" do
      processed = "" |> ScriptSigils.strip
      assert processed == ""
    end

    test "no-op with sigil-less scripts" do
      script = """
      defmodule Hello do
        def World do
          :dennis_rocks
        end
      end
      """
      processed = script |> ScriptSigils.strip
      assert processed == script
    end

    test ~S{no-op with =~} do
      script = """
      defmodule Hello do
        def World do
          "foo" =~ "bar"
        end
      end
      """
      processed = script |> ScriptSigils.strip
      assert processed == script
    end


    sigil_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                  |> String.graphemes

    for char <- sigil_chars do
      test "strip contents from #{char} sigils" do
        script = """
        defmodule Sneaky do
          def String do
            ~#{unquote(char)}|Hello, world|
            ~#{unquote(char)}"Hello, world"
            ~#{unquote(char)}'Hello, world'
            ~#{unquote(char)}(Hello, world)
            ~#{unquote(char)}[Hello, world]
            ~#{unquote(char)}{Hello, world}
            ~#{unquote(char)}<Hello, world>
            ~#{unquote(char)}/Hello, world/
          end
        end
        """
        desired = """
        defmodule Sneaky do
          def String do
            ~#{unquote(char)}||
            ~#{unquote(char)}""
            ~#{unquote(char)}''
            ~#{unquote(char)}()
            ~#{unquote(char)}[]
            ~#{unquote(char)}{}
            ~#{unquote(char)}<>
            ~#{unquote(char)}//
          end
        end
        """
        assert desired == script |> ScriptSigils.strip
      end
    end

    test "handle escaped closing delimiters" do
      script = ~S"""
      defmodule Sneaky do
        def String do
          ~s|Hello, \| world|
          ~s"Hello, \" world"
          ~s'Hello, \' world'
          ~s(Hello, \) world)
          ~s[Hello, \] world]
          ~s{Hello, \} world}
          ~s<Hello, \> world>
          ~s/Hello, \/ world/
        end
      end
      """
      desired = """
      defmodule Sneaky do
        def String do
          ~s||
          ~s""
          ~s''
          ~s()
          ~s[]
          ~s{}
          ~s<>
          ~s//
        end
      end
      """
      assert desired == script |> ScriptSigils.strip
    end

    test "preserve newlines" do
      script = ~S"""
      defmodule Sneaky do
        def String do
          ~s(
            Hi
            )
        end
      end
      """
      desired = """
      defmodule Sneaky do
        def String do
          ~s(

)
        end
      end
      """
      assert desired == script |> ScriptSigils.strip
    end

    test "handle utf8 characters" do
      desired = """
      defmodule Foo do
        def foo do
          "Ó"
        end
      end
      """
      assert desired == desired |> ScriptSigils.strip
    end
  end
end
