defmodule Dogma.ReportersTest do
  use ShouldI

  alias Dogma.Reporters

  with ".reporters" do
    should "return a map containing each reporter" do
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
