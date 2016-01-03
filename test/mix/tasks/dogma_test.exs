defmodule Dogma.OptionParserTest do
  use ShouldI

  @default_reporter Dogma.Reporters.default_reporter

  defp parse_args(args) do
    Mix.Tasks.Dogma.parse_args(args)
  end

  having ".parse_args" do
    having "empty args" do
      should "return nil and default reporter" do
        assert parse_args([]) == {nil, @default_reporter, false}
      end
    end

    having "directories given" do
      should "return directory and default reporter" do
        assert parse_args(["lib/foo"]) == {"lib/foo", @default_reporter, false}
      end

      having "multiple directories given" do
        should "return first directory only" do
          parsed = parse_args(["lib/foo", "lib/bar"])
          assert parsed == {"lib/foo", @default_reporter, false}
        end
      end
    end

    having "format option passed" do
      having "simple passed" do
        should "return simple reporter" do
          parsed = parse_args(["--format", "simple"])
          assert parsed == {nil, Dogma.Reporter.Simple, false}
        end
      end

      having "flycheck passed" do
        should "return flycheck reporter" do
          parsed = parse_args(["--format=flycheck"])
          assert parsed == {nil, Dogma.Reporter.Flycheck, false}
        end
      end

      having "unknown reporter passed" do
        should "return default reporter" do
          parsed = parse_args(["--format", "false"])
          assert parsed == {nil, @default_reporter, false}
        end
      end
    end

    having "no-error option passed" do
      should "return disabled error exit code" do
        parsed = parse_args(["--no-error"])
        assert parsed == {nil, @default_reporter, true}
      end
    end
  end
end
