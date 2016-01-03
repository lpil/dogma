defmodule Dogma.Reporter.SimpleTest do
  use ShouldI

  import ExUnit.CaptureIO

  alias Dogma.Reporter.Simple
  alias Dogma.Script
  alias Dogma.Error

  @one_file [ %Script{ errors: [] } ]
  @many_files [ %Script{}, %Script{}, %Script{} ]

  @no_errors %Script{ errors: [] }
  @some_errors %Script{ errors: [%Error{}] }

  @files_no_errors [ %Script{ }, %Script{} ]
  @files_some_errors [
    %Script{
      path: "foo.ex",
      errors: [%Error{ rule: Foo.BadCode,    line: 44, message: "Awful." }]
    },
    %Script{},
    %Script{},
    %Script{
      path: "bar.ex",
      errors: [
        %Error{ rule: Foo.Confusing,  line: 2,  message: "Wtf?" },
        %Error{ rule: Foo.UglyAsHell, line: 63, message: "Not ok." }
      ]
    },
  ]

  having ".handle_event" do
    having "start event" do
      should "print no tests message when there are no tests" do
        assert capture_io(fn ->
          Simple.handle_event({:start, []}, [])
        end) == "No tests to run!\n\n"
      end

      should "print singular test with only one file" do
        assert capture_io(fn ->
          Simple.handle_event({:start, @one_file}, [])
        end) == "Inspecting 1 file.\n\n"
      end

      should "print a plural message with multiple files to lint" do
        assert capture_io(fn ->
          Simple.handle_event({:start, @many_files}, [])
        end) == "Inspecting 3 files.\n\n"
      end
    end

    having "script_tested event" do
      should "print a green dot with now errors" do
        assert capture_io(fn ->
          Simple.handle_event({:script_tested, @no_errors}, [])
        end) == "\e[32m.\e[0m"
      end

      should "print a red X with some errors" do
        assert capture_io(fn ->
          Simple.handle_event({:script_tested, @some_errors}, [])
        end) == "\e[31mX\e[0m"
      end
    end

    having "finished event" do
      should "print success message with no errors" do
        assert capture_io(fn ->
          Simple.handle_event({:finished, @files_no_errors}, [])
        end) == "\n\n2 files, \e[32mno errors!\e[0m\n\n"
      end

      should "print count, followed by detail with some errors" do
        assert capture_io(fn ->
          Simple.handle_event({:finished, @files_some_errors}, [])
        end) == """
        \n\n4 files, \e[31m3 errors!\e[0m

        == foo.ex ==
        44: BadCode: Awful.

        == bar.ex ==
        2: Confusing: Wtf?
        63: UglyAsHell: Not ok.

        """
      end
    end
  end
end
