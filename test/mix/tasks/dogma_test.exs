defmodule Dogma.OptionParserTest do
  use ShouldI

  @default_formatter Dogma.Formatter.default_formatter

  defp parse_args(args) do
    Mix.Tasks.Dogma.parse_args(args)
  end

  with ".parse_args" do
    with "empty args" do
      should "return nil and default formatter and fix set to false" do
        {dir, options} = parse_args([])
        assert dir == nil
        assert options == %{fix?: false, formatter: @default_formatter}
      end
    end

    with "directories given" do
      should "return directory and default formatter and fix set to false" do
        {path, options} = parse_args(["lib/foo"])
        assert path == "lib/foo"
        assert match?( %{fix?: false, formatter: @default_formatter}, options)
      end

      with "multiple directories given" do
        should "return first directory only" do
          {dir, _}  = parse_args(["lib/foo", "lib/bar"])
          assert dir == "lib/foo"
        end
      end
    end

    with "format option passed" do
      with "simple passed" do
        should "return simple formatter" do
          {_, options} = parse_args(["--format", "simple"])
          assert match?( %{formatter: Dogma.Formatter.Simple}, options )
        end
      end

      with "flycheck passed" do
        should "return flycheck formatter" do
          {_, options} = parse_args(["--format=flycheck"])
          assert match?( %{formatter: Dogma.Formatter.Flycheck}, options )
        end
      end

      with "unknown formatter passed" do
        should "return default formatter" do
          {_, options} = parse_args(["--format", "false"])
          assert match?( %{formatter: @default_formatter}, options )
        end
      end
    end

    with "--fix passed" do
      should "add fix: true to the options" do
        {_, options} = parse_args(["--fix"])
        assert match?( %{fix?: true}, options )
      end
    end
  end
end
