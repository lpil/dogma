defmodule Dogma do
  @moduledoc """
  Welcome to Dogma.

  This module is our entry point, and does nothing but deligate to various
  other modules through the divine `run/2` function.
  """

  alias Dogma.Formatter
  alias Dogma.Rules
  alias Dogma.ScriptSources
  alias Dogma.Corrections

  def run({dir, %{formatter: formatter, fix?: fix?} = opts}) do
    dir
    |> ScriptSources.find(exclude_patterns)
    |> ScriptSources.to_scripts
    |> Formatter.start(formatter)
    |> Rules.test(formatter)
    |> Corrections.repair(fix?)
    |> Formatter.finish(opts)
  end

  defp exclude_patterns do
    Application.get_env :dogma, :exclude, []
  end
end
