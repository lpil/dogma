defmodule Mix.Tasks.Dogma do
  use Mix.Task

  @shortdoc  "Check Elixir source files for style violations"
  @moduledoc @shortdoc

  alias Dogma.Config
  alias Dogma.Formatter

  def run(argv) do
    {dir, formatter} = argv |> parse_args
    config = Config.build

    dir
    |> Dogma.run(config, formatter)
    |> any_errors?
    |> if do
      System.halt(666)
    end
  end

  def parse_args(argv) do
    switches = [format: :string]
    {switches, files, []} = OptionParser.parse(argv, switches: switches)

    format = Keyword.get(switches, :format)
    formatter = Map.get(
      Formatter.formatters,
      format,
      Formatter.default_formatter
    )

    {List.first(files), formatter}
  end

  defp any_errors?(scripts) do
    scripts
    |> Enum.any?( &Enum.any?( &1.errors ) )
  end
end
