defmodule Dogma.OptionParserTest do
  use ShouldI

  @default_formatter Dogma.Formatter.default_formatter

  defp parse_args(args) do
    Mix.Tasks.Dogma.parse_args(args)
  end

  with ".parse_args" do
    with "empty args" do
      should "return nil and default formatter" do
        assert parse_args([]) == {nil, @default_formatter, false}
      end
    end

    with "directories given" do
      should "return directory and default formatter" do
        assert parse_args(["lib/foo"]) == {"lib/foo", @default_formatter, false}
      end

      with "multiple directories given" do
        should "return first directory only" do
          parsed = parse_args(["lib/foo", "lib/bar"])
          assert parsed == {"lib/foo", @default_formatter, false}
        end
      end
    end

    with "format option passed" do
      with "simple passed" do
        should "return simple formatter" do
          parsed = parse_args(["--format", "simple"])
          assert parsed == {nil, Dogma.Formatter.Simple, false}
        end
      end

      with "flycheck passed" do
        should "return flycheck formatter" do
          parsed = parse_args(["--format=flycheck"])
          assert parsed == {nil, Dogma.Formatter.Flycheck, false}
        end
      end

      with "unknown formatter passed" do
        should "return default formatter" do
          parsed = parse_args(["--format", "false"])
          assert parsed == {nil, @default_formatter, false}
        end
      end
    end

    with "noerrors option passed" do
      should "return disabled error exit code" do
          parsed = parse_args(["--noerrors"])
          assert parsed == {nil, @default_formatter, true}
      end
    end
  end
end
