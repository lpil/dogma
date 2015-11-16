defmodule Dogma.Util.ScriptSigilsTest do
  use ShouldI

  alias Dogma.Util.ScriptSigils

  with "strip/1" do
    should "no-op with empty scripts" do
      processed = "" |> ScriptSigils.strip
      assert processed == ""
    end

    should "no-op with sigil-less scripts" do
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

    should ~S{no-op with =~} do
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
      should "strip contents from #{char} sigils" do
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
          end
        end
        """
        assert desired == script |> ScriptSigils.strip
      end
    end

    should "handle escaped closing delimiters" do
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
        end
      end
      """
      assert desired == script |> ScriptSigils.strip
    end

    should "preserve newlines" do
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
  end
end
