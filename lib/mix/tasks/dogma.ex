defmodule Mix.Tasks.Dogma do
  use Mix.Task

  @shortdoc  "Check Elixir source files for style violations"
  @moduledoc @shortdoc

  alias Dogma.Config
  alias Dogma.Formatter

  def run(argv) do
    {dir, formatter, noerrors} = argv |> parse_args
    config = Config.build

    dir
    |> Dogma.run(config, formatter)
    |> any_errors?
    |> if do
      if !noerrors do
        System.halt(666)
      end
    end
  end

  def parse_args(argv) do
    switches = [format: :string, noerrors: :boolean]
    {switches, files, []} = OptionParser.parse(argv, switches: switches)

    noerrors = Keyword.get(switches, :noerrors, false)
    format = Keyword.get(switches, :format)
    formatter = Map.get(
      Formatter.formatters,
      format,
      Formatter.default_formatter
    )

    {List.first(files), formatter, noerrors}
  end

  defp any_errors?(scripts) do
    scripts
    |> Enum.any?( &Enum.any?( &1.errors ) )
  end
end
