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
    Enum.reduce( overrides, rules, &reconfigure_rule/2 )
  end

  defp get_exclude do
    Application.get_env( :dogma, :exclude, [] )
  end

  defp reconfigure_rule({rule, false}, rules) do
    Dict.delete( rules, rule )
  end
  defp reconfigure_rule({rule, config}, rules) do
    Dict.put( rules, rule, config )
  end
end
