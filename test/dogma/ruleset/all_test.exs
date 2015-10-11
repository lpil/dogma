defmodule Dogma.RuleSet.AllTest do
  use ShouldI

  alias Dogma.RuleSet.All

  with "rules/0" do

    @mod_regex ~r/\A[A-Z][A-Za-z\.]+\z/

    should "map module names to config keyword lists" do
      for {name, config} <- All.rules do
        assert config |> is_list
        assert name |> to_string |> String.match?(@mod_regex)
      end
    end

    should "return a module for each file in lib/dogma/rule/" do
      dir_size = "lib/dogma/rule/*.ex" |> Path.wildcard |> length
      set_size = All.rules |> Dict.size
      assert dir_size == set_size
    end

    should "contain LiteralInCondition" do
      assert All.rules |> Dict.has_key?( LiteralInCondition )
    end
  end
end
