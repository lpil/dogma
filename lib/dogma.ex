defmodule Dogma do
  @moduledoc """
  Welcome to Dogma.

  This module is our entry point, and does nothing but deligate to various
  other modules through the divine `run/3` function.
  """

  alias Dogma.Rules
  alias Dogma.ScriptSources

  @version Mix.Project.config[:version]

  def run(dir_or_file, config, dispatcher) do
    dir_or_file
    |> ScriptSources.find(config.exclude)
    |> ScriptSources.to_scripts
    |> notify_start(dispatcher)
    |> Rules.test(config.rules, dispatcher)
    |> notify_finish(dispatcher)
  end

  def version, do: @version

  defp notify_start(scripts, dispatcher) do
    GenEvent.sync_notify(dispatcher, {:start, scripts})
    scripts
  end

  defp notify_finish(scripts, dispatcher) do
    GenEvent.sync_notify(dispatcher, {:finished, scripts})
    scripts
  end
end
