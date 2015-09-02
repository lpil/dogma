defmodule Dogma.FormatterTest do
  use ShouldI

  import ExUnit.CaptureIO

  alias Dogma.Formatter

  defmodule TestFormatter do
    def start(_)  do "start"  end
    def script(_) do "script" end
    def finish(_) do "finish" end
  end

  with ".start" do
    should "print with the formatter" do
      assert "start" == capture_io(fn ->
        Formatter.start( [], TestFormatter )
      end)
    end
  end

  with ".script" do
    should "print with the formatter" do
      assert "script" == capture_io(fn ->
        Formatter.script( [], TestFormatter )
      end)
    end
  end

  with ".finish" do
    should "print with the formatter" do
      assert "finish" == capture_io(fn ->
        Formatter.finish( [], TestFormatter )
      end)
    end
  end

  with ".formatters" do
    should "return a map containing each formatter" do
      actual =
        "lib/dogma/formatter/*.ex"
        |> Path.wildcard
        |> length

      expected =
        Formatter.formatters
        |> Map.to_list
        |> length

      assert expected == actual
    end
  end
end
