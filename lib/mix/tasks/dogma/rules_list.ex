defmodule Mix.Tasks.Dogma.RulesList do
  use Mix.Task

  @shortdoc  "Generate documentation file detailing all rules"
  @moduledoc "Generate documentation file detailing all rules"

  def run(_) do
    File.write!( "docs/rules.md", rules_doc )
  end

  @doc """
  Generate a string documenting all the available rules.

  Gets the information from the `@moduledoc`s of each Rule module.
  """
  def rules_doc do
    docs =
    Dogma.Rules.Sets.All.list
    |> Enum.map(&rule_tuple_to_name/1)
    |> Enum.map(&moduledoc/1)
    |> Enum.join("\n")

    """
    # Dogma Rules

    These are the rules included in Dogma by default.

    #{docs}
    """
  end


  defp rule_tuple_to_name(tuple) do
    tuple |> Tuple.to_list |> hd
  end

  defp moduledoc(rule) do
    {_, doc} = Code.get_docs( namespace(rule), :moduledoc )
    """
    ## #{printable_name rule}

    #{doc}
    """
  end

  defp namespace(name) do
    Module.concat( Dogma.Rules, name )
  end

  defp printable_name(rule) do
    rule
    |> Module.split
    |> hd
  end
end
