defmodule Dogma.Reporter.FlycheckTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias Dogma.Reporter.Flycheck
  alias Dogma.Script
  alias Dogma.Error

  describe "no errors" do
    setup context do
      Dict.put(context, :script, [%Script{ errors: [] }])
    end

    test "output newline to console", context do
      assert capture_io(fn ->
        Flycheck.handle_event({:finished, context.script}, [])
      end) == "\n"
    end
  end

  describe "some errors" do
    setup context do
      error1 = %Error{
        line: 1,
        message: "Module without a @moduledoc detected"
      }
      error2 = %Error{
        line: 14,
        message: "Comparison to a boolean is pointless"
      }
      error3 = %Error{
        line: 23,
        message: "Unexpected token",
        rule: SyntaxError
      }

      script = [
        %Script{ path: "foo.ex", errors: [error1, error3] },
        %Script{ path: "bar.ex", errors: [error1, error2] },
        %Script{ path: "baz.ex", errors: [] }
      ]

      Dict.put(context, :script, script)
    end

    test "print each error to console", context do
      expected = """
      foo.ex:1:1: W: Module without a @moduledoc detected
      foo.ex:23:1: E: Unexpected token
      bar.ex:1:1: W: Module without a @moduledoc detected
      bar.ex:14:1: W: Comparison to a boolean is pointless
      """

      assert capture_io(fn ->
        Flycheck.handle_event({:finished, context.script}, [])
      end) == expected
    end
  end
end
