defmodule Dogma.RuleSet.AllTest do
  use ExUnit.Case, async: true

  alias Dogma.RuleSet.All

  describe "rules/0" do
    test "return a module for each file in lib/dogma/rule/" do
      dir_size = "lib/dogma/rule/*.ex" |> Path.wildcard |> length
      set_size = All.rules |> length
      assert dir_size == set_size
    end

    test "contain a known rule struct" do
      assert All.rules |> Enum.member?( %Dogma.Rule.LiteralInCondition{} )
    end
  end
end
