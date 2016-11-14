defmodule Dogma do
  @moduledoc """
  Dogma is a tool for enforcing a consistent Elixir code style within your
  project,the idea being that if your code is easier to read, it should also be
  easier to understand.

  It's highly configurable so you can adjust it to fit
  your style guide, but comes with a sane set of defaults so for most people it
  should just work out-of-the-box.

  This module is our entry point, and does nothing but delegates to various
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
