defmodule Dogma.Rules do

  to_rule_name = fn path ->
    name = path
            |> Path.basename(".ex")
            |> Mix.Utils.camelize
            |> String.to_atom
    Module.concat( Dogma.Rules, name )
  end

  rules = "lib/dogma/rules/*.ex"
          |> Path.wildcard
          |> Enum.map(to_rule_name)


  @doc """
  Returns a list of all modules that define a Dogma rule.
  """
  def list do
    unquote(rules)
  end
end
