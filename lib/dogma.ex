defmodule Dogma do
  @moduledoc """
  Welcome to Dogma.

  This module is our entry point, and does nothing but deligate to various
  other modules through the divine `run/3` function.
  """

  alias Dogma.Formatter
  alias Dogma.Rules
  alias Dogma.ScriptSources

  @version Mix.Project.config[:version]

  def run(dir, config, formatter) do
    dir
    |> ScriptSources.find(config.exclude)
    |> ScriptSources.to_scripts
    |> Formatter.start(formatter)
    |> Rules.test(config.rules, formatter)
    |> Formatter.finish(formatter)
  end

  def version, do: @version
end
