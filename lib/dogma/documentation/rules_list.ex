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
    modules  = all_rule_modules
    contents = modules |> Enum.map(&contents_entry/1)
    docs     = modules |> Enum.map(&moduledoc/1) |> Enum.join("\n")
    """
    # Dogma Rules

    These are the rules included in Dogma by default. Currently there are
    #{length modules} of them.

    ## Contents

    #{contents}

    ---

    #{docs}
    """
  end


  defp all_rule_modules do
    Dogma.RuleSet.All.rules
    |> Enum.map(&( &1.__struct__ ))
  end

  defp contents_entry(rule) do
    name = rule |> printable_name
    id   = name |> String.downcase
    """
    * [#{name}](##{id})
    """
  end


  defp moduledoc(module) do
    {_, doc} = Code.get_docs( module, :moduledoc )
    """
    ### #{printable_name module}

    #{doc}
    """
  end

  defp printable_name(rule) do
    rule
    |> Module.split
    |> List.last
  end
end
