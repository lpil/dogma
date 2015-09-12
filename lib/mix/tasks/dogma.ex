defmodule Mix.Tasks.Dogma do
  use Mix.Task

  @shortdoc  "Check Elixir source files for style violations"
  @moduledoc @shortdoc

  alias Dogma.Formatter

  def run(argv) do
    argv
    |> parse_args
    |> Dogma.run
    |> any_errors?
    |> if do
      System.halt(666)
    end
  end

  def parse_args(argv) do
    switches = [format: :string, fix: :boolean]
    {switches, files, []} = OptionParser.parse(argv, switches: switches)

    format = Keyword.get(switches, :format)
    formatter = Map.get(Formatter.formatters,
                        format,
                        Formatter.default_formatter)
    fix = Keyword.get(switches, :fix, false)

    {List.first(files), %{formatter: formatter, fix: fix}}
  end

  defp any_errors?(scripts) do
    scripts
    |> Enum.any?( &Enum.any?( &1.errors ) )
  end
end
