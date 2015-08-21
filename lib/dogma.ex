defmodule Dogma do
  @moduledoc """
  Welcome to Dogma.

  This module is our entry point, and does nothing but deligate to various
  other modules through the divine `run/2` function.
  """

  alias Dogma.Formatter
  alias Dogma.Rules
  alias Dogma.ScriptSources

  def run(dir_path \\ "", rule_set \\ nil) do
    dir_path
    |> ScriptSources.find
    |> ScriptSources.to_scripts
    |> Formatter.start
    |> Rules.test( rule_set )
    |> Formatter.finish
  end

end
