defmodule Dogma.Config do
  @moduledoc """
  Responsible for gathering all the configuration state required to run Dogma.
  """

  defstruct(
    rules:   [],
    exclude: [],
  )


  @default_set Dogma.RuleSet.All


  @doc """
  Build the config struct for the current project.
  """
  def build do
    %__MODULE__{
      rules:   get_rules,
      exclude: get_exclude,
    }
  end

  defp get_rules do
    rules     = Application.get_env( :dogma, :rule_set, @default_set ).rules
    overrides = Application.get_env( :dogma, :override, %{} )
    rules_map = Enum.reduce( rules, %{}, &insert_rule/2 )
    overrides
    |> Enum.reduce( rules_map, &insert_rule/2 )
    |> Dict.values
  end

  defp get_exclude do
    Application.get_env( :dogma, :exclude, [] )
  end


  defp insert_rule(rule, acc) when is_map(rule) do
    Dict.put(acc, rule.__struct__, rule)
  end

  defp insert_rule({rule_name, config}, acc)
  when is_atom(rule_name) and is_list(config) do
    name =
      rule_name
      |> to_string
      |> String.split(".")
      |> tl
      |> Enum.join(".")
    conf =
      config
      |> inspect
      |> String.replace("[", "{")
      |> String.replace("]", "}")
    IO.write """
    The Dogma rule override format used for #{name} has been deprecated.

    Please update your config to use the new format like so:

    config :dogma,
      override: [
        %Dogma.Rule.#{name}#{conf},
      ]

    https://github.com/lpil/dogma/blob/master/docs/configuration.md
    """
    acc
  end
end
