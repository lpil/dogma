defmodule Dogma.Documentation.RuleList do
  @shortdoc  "Generate documentation file detailing all rules"
  @moduledoc "Generate documentation file detailing all rules"

  def write! do
    File.write!( "docs/rules.md", rules_doc )
    IO.puts "Generated docs/rules.md"
  end

  @doc """
  Generate a string documenting all the available rules.

  Gets the information from the `@moduledoc`s of each Rule module.
  """
  def rules_doc do
    rules    = all_rules
    contents = rules |> Enum.map(&contents/1)
    docs     = rules
                |> Enum.map(&moduledoc/1)
                |> Enum.join("\n")
    """
    # Dogma Rules

    These are the rules included in Dogma by default. Currently there are
    #{length rules} of them.

    ## Contents

    #{contents}

    ---

    #{docs}
    """
  end


  defp all_rules do
    Dogma.RuleSet.All.rules
    |> Enum.map(&rule_tuple_to_name/1)
  end

  defp rule_tuple_to_name(tuple) do
    tuple |> Tuple.to_list |> hd
  end

  defp contents(rule) do
    name = rule |> printable_name
    id   = name |> String.downcase
    """
    * [#{name}](##{id})
    """
  end


  defp moduledoc(rule) do
    {_, doc} = Code.get_docs( namespace(rule), :moduledoc )
    """
    ### #{printable_name rule}

    #{doc}
    """
  end

  defp namespace(name) do
    Module.concat( Dogma.Rule, name )
  end

  defp printable_name(rule) do
    rule
    |> Module.split
    |> hd
  end
end
