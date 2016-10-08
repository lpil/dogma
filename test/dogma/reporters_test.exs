defmodule Dogma.ReportersTest do
  use ExUnit.Case, async: true

  alias Dogma.Reporters

  describe ".reporters" do
    test "return a map containing each reporter" do
      actual =
        "lib/dogma/reporter/*.ex"
        |> Path.wildcard
        |> length

      expected =
        Reporters.reporters
        |> Map.to_list
        |> length

      assert expected == actual
    end
  end
end
