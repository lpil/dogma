defmodule Dogma.Documentation.FormattersList do
  @moduledoc """
  Generates a documentation file for formatters.
  """

  alias Dogma.Formatter

  @doc """
  Writes formatter documentation to `docs/formatters.md`.
  """
  def write! do
    File.write!("docs/formatters.md", formatters_doc)
    IO.puts "Generated docs/formatters.md"
  end

  @doc """
  Generate a markdown string documenting the available formatters.

  Available formatters are determined by `Dogma.Formatter.formatters` and the
  information for each formatter is pulled from that module's `@moduledoc`
  """
  def formatters_doc do
    formatters =
      Formatter.formatters
      |> Enum.map(&extract_doc/1)

    default_name = printable_name(Formatter.default_formatter)
    default_id   = String.downcase(default_name)

    """
    # Dogma Formatters

    You can pass a format to the mix task using the `--format` flag.

    ```
    > mix dogma --format=flycheck

    lib/dogma/rules.ex:23:1: W: Blank lines detected at end of file
    test/dogma/formatter_test.exs:9:1: W: Trailing whitespace detected
    ```

    The default formatter is [#{default_name}](##{default_id}).

    ## Contents

    #{contents(formatters)}

    ---

    #{moduledoc(formatters)}

    """
  end

  defp extract_doc({key, formatter}) do
    name = printable_name(formatter)
    {_, doc} = Code.get_docs(formatter, :moduledoc)

    {name, doc, key}
  end

  defp printable_name(module) do
    module
    |> Module.split
    |> List.last
  end

  defp contents(formatters) when is_list(formatters) do
    formatters
    |> Enum.map(&contents/1)
  end

  defp contents({name, _, _}) do
    id = String.downcase(name)
    """
    * [#{name}](##{id})
    """
  end

  defp moduledoc(formatters) when is_list(formatters) do
    formatters
    |> Enum.map(&moduledoc/1)
    |> Enum.join("\n")
  end

  defp moduledoc({name, doc, key}) do
    """
    ### #{name}
    `#{key}`

    #{doc}
    """
  end
end
