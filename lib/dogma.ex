defmodule Dogma do
  @moduledoc """
  Welcome to Dogma.

  This module is our entry point, and does nothing but deligate to various
  other modules through the divine `run/2` function.
  """

  alias Dogma.Formatter
  alias Dogma.Rules
  alias Dogma.ScriptSources

  def run({dir, formatter}) do
    dir
    |> ScriptSources.find
    |> ScriptSources.to_scripts
    |> Formatter.start(formatter)
    |> Rules.test(formatter)
    |> Formatter.finish(formatter)
  end
end
