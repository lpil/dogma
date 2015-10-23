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
    Application.get_env( :dogma, :rule_set, @default_set ).rules
  end

  defp get_exclude do
    Application.get_env( :dogma, :exclude, [] )
  end
end
