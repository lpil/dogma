defmodule Mix.Tasks.Dogma do
  use Mix.Task

  @shortdoc "Check Elixir source files for style offences"

  def run(_) do
    Dogma.run
  end
end
