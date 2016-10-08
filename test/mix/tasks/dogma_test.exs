defmodule Dogma.OptionParserTest do
  use ExUnit.Case, async: true

  @default_reporter Dogma.Reporters.default_reporter

  defp parse_args(args) do
    Mix.Tasks.Dogma.parse_args(args)
  end

  describe ".parse_args/1" do
    test "empty args return nil and default reporter" do
      assert parse_args([]) == {nil, @default_reporter, false}
    end

    test "directories given: return directory and default reporter" do
      assert parse_args(["lib/foo"]) == {"lib/foo", @default_reporter, false}
    end

    test "multiple directories passed: return first directory only" do
      parsed = parse_args(["lib/foo", "lib/bar"])
      assert parsed == {"lib/foo", @default_reporter, false}
    end

    test "simple format reporter" do
      parsed = parse_args(["--format", "simple"])
      assert parsed == {nil, Dogma.Reporter.Simple, false}
    end

    test "flycheck reporter" do
      parsed = parse_args(["--format=flycheck"])
      assert parsed == {nil, Dogma.Reporter.Flycheck, false}
    end

    test "unknown reporter reporter" do
      parsed = parse_args(["--format", "false"])
      assert parsed == {nil, @default_reporter, false}
    end

    test "exit code" do
      parsed = parse_args(["--no-error"])
      assert parsed == {nil, @default_reporter, true}
    end
  end
end
