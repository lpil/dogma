defmodule Dogma.Rules do
  @moduledoc """
  The module under which we namespace individual rules.

  Rules to be run are returned by `list/0`
  """

  to_rule_name = fn path ->
    name = path
            |> Path.basename(".ex")
            |> Mix.Utils.camelize
            |> String.to_atom
    Module.concat( Dogma.Rules, name )
  end

  files = Path.wildcard( "lib/dogma/rules/*.ex" )
  rules = Enum.map( files, to_rule_name )

  # FIXME: This doesn't work. Removing a file doesn't trigger recompile.
  for file <- files do
    @external_resource file
  end

  @doc """
  Returns a list of all modules that define a Dogma rule.
  """
  def list do
    unquote(rules)
  end
end
