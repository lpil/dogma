defmodule Dogma.Formatter.SimpleTest do
  use ShouldI

  alias Dogma.Formatter.Simple
  alias Dogma.Script
  alias Dogma.Error

  with ".start" do
    with "no files to lint" do
      should "print no tests message" do
        assert "No tests to run!\n\n" == Simple.start( [] )
      end
    end

    with "one file to lint" do
      should "prints a singular test message" do
        files = [ %Script{} ]
        assert "Inspecting 1 file.\n\n" == Simple.start( files )
      end
    end

    with "two files to lint" do
      should "prints a plural test message" do
        files = [ %Script{}, %Script{}, %Script{} ]
        assert "Inspecting 3 files.\n\n" == Simple.start( files )
      end
    end
  end


  with ".script" do
    with "no errors" do
      should "print a green ." do
        script = %Script{ errors: [] }
        assert "\e[32m.\e[0m" == Simple.script( script )
      end
    end

    with "some errors" do
      should "print a red X" do
        script = %Script{ errors: [%Error{}] }
        assert "\e[31mX\e[0m" == Simple.script( script )
      end
    end
  end

  with ".finish" do
    with "no errors" do
      should "print a success message" do
        formatted = [ %Script{}, %Script{} ] |> Simple.finish
        assert "\n\n2 files, \e[32mno errors!\e[0m\n\n" == formatted
      end
    end
  end

  with "An error" do
    setup context do
      error = %Error{ rule: Foo.BadCode, line: 44, message: "Awful." }
      %{
        scripts: [ %Script{ path: "foo.ex", errors: [error] }, %Script{} ]
      }
    end

    should "print count, followed by detail", context do
      output  = """
      \n\n2 files, \e[31m1 error!\e[0m

      == foo.ex ==
      44: BadCode: Awful.

      """
      assert output == Simple.finish( context.scripts )
    end
  end

  with "Several errors" do
    setup context do
      error1 = %Error{ rule: Foo.BadCode,    line: 44, message: "Awful." }
      error2 = %Error{ rule: Foo.Confusing,  line: 2,  message: "Wtf?" }
      error3 = %Error{ rule: Foo.UglyAsHell, line: 63, message: "Not ok." }
      %{
        scripts: [
          %Script{ path: "foo.ex", errors: [error1] },
          %Script{},
          %Script{},
          %Script{ path: "bar.ex", errors: [error2, error3] },
        ]
      }
    end

    should "print count, followed by details", context do
      output  = """
      \n\n4 files, \e[31m3 errors!\e[0m

      == foo.ex ==
      44: BadCode: Awful.

      == bar.ex ==
      2: Confusing: Wtf?
      63: UglyAsHell: Not ok.

      """
      assert output == Simple.finish( context.scripts )
    end
  end
end
