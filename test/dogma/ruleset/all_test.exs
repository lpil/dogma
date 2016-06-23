defmodule Dogma.RuleSet.AllTest do
  use ShouldI

  alias Dogma.RuleSet.All

  having "rules/0" do
    @mod_regex ~r/\A[A-Z][A-Za-z\.]+\z/

    should "return a module for each file in lib/dogma/rule/" do
      dir_size = "lib/dogma/rule/*.ex" |> Path.wildcard |> length
      set_size = All.rules |> length
      assert dir_size == set_size
    end

    should "contain a known rule struct" do
      assert All.rules |> Enum.member?( %Dogma.Rule.LiteralInCondition{} )
    end
  end
end
