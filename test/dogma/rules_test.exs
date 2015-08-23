defmodule Dogma.Rules.RulesTest do
  use ShouldI

  alias Dogma.Rules
  alias Dogma.RuleSet

  # Let's ensure that all rules have a test function.
  # They're not useful otherwise.

  for rule <- RuleSet.All.list do

    module = case rule do
      {name}    -> name
      {name, _} -> name
    end

    module_name = module |> Module.split |> hd |> String.to_atom

    should "have test/1 function defined for rule #{module_name}" do
      functions = Rules.unquote(module).__info__( :functions )
      assert Enum.member?( functions, {:test, 1} )
    end
  end
end
