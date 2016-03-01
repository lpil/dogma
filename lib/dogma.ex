defmodule Dogma do
  @moduledoc """
  Welcome to Dogma.

  This module is our entry point, and does nothing but deligate to various
  other modules through the divine `run/3` function.
  """

  alias Dogma.Rules
  alias Dogma.ScriptSources
  alias Dogma.Script

  @version Mix.Project.config[:version]

  def run(dir_or_file, config, dispatcher) do
    dir_or_file
    |> get_sources(config)
    |> notify_start(dispatcher)
    |> Rules.test(config.rules, dispatcher)
    |> notify_finish(dispatcher)
  end

  def get_sources(dir_or_file, %{read_stdin: true} = _config) do
    if dir_or_file == nil, do: dir_or_file="stdin"
    case read_from_stdin do
      {:ok, source} -> [source |> Script.parse(dir_or_file)]
      _ -> System.halt(666)
    end
  end

  def get_sources(dir_or_file, config) do
    dir_or_file
    |> ScriptSources.find(config.exclude)
    |> ScriptSources.to_scripts
  end

  def version, do: @version

  defp read_from_stdin(source \\ "") do
    case IO.read(:stdio, :line) do
      {:error, reason} -> {:error, reason}
      :eof             -> {:ok, source}
      data             -> source = source <> data
        read_from_stdin(source)
    end
  end

  defp notify_start(scripts, dispatcher) do
    GenEvent.sync_notify(dispatcher, {:start, scripts})
    scripts
  end

  defp notify_finish(scripts, dispatcher) do
    GenEvent.sync_notify(dispatcher, {:finished, scripts})
    scripts
  end
end
