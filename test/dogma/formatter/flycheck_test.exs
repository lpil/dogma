defmodule Dogma.Formatter.FlycheckTest do
  use ShouldI

  alias Dogma.Formatter.Flycheck
  alias Dogma.Script
  alias Dogma.Error

  with ".start" do
    with "no files to list" do
      should "print nothing" do
        assert Flycheck.start([]) == ""
      end
    end

    with "some files to lint" do
      should "print nothing" do
        script = [%Script{}, %Script{}, %Script{}]
        assert Flycheck.start(script) == ""
      end
    end
  end

  with ".script" do
    with "no errors" do
      should "print nothing" do
        script = %Script{ errors: [] }
        assert Flycheck.script(script) == ""
      end
    end

    with "some errors" do
      should "print nothing" do
        script = %Script{ errors: [%Error{}] }
        assert Flycheck.script(script) == ""
      end
    end
  end

  with ".finish" do
    with "no errors" do
      should "print a new line" do
        script = [%Script{ errors: [] }]
        assert Flycheck.finish(script) == "\n"
      end
    end

    with "some errors" do
      should "print each error" do
        error1 = %Error{
          line: 1,
          message: "Module without a @moduledoc detected"
        }
        error2 = %Error{
          line: 14,
          message: "Comparison to a boolean is pointless"
        }

        script = [
          %Script{ path: "foo.ex", errors: [error1] },
          %Script{ path: "bar.ex", errors: [error1, error2] },
          %Script{ path: "baz.ex", errors: [] }
        ]

        expected = """
        foo.ex:1:1: W: Module without a @moduledoc detected
        bar.ex:1:1: W: Module without a @moduledoc detected
        bar.ex:14:1: W: Comparison to a boolean is pointless
        """

        assert Flycheck.finish(script) == expected
      end
    end
  end
end
