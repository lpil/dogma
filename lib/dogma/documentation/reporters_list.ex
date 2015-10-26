defmodule Dogma.Documentation.ReportersList do
  @moduledoc """
  Generates a documentation file for reporters.
  """

  alias Dogma.Reporters

  @doc """
  Writes reporter documentation to `docs/reporters.md`.
  """
  def write! do
    File.write!("docs/reporters.md", reporters_doc)
    IO.puts "Generated docs/reporters.md"
  end

  @doc """
  Generate a markdown string documenting the available reporters.

  Available reporters are determined by `Dogma.Reporters.reporters` and the
  information for each reporter is pulled from that module's `@moduledoc`
  """
  def reporters_doc do
    reporters =
      Reporters.reporters
      |> Enum.map(&extract_doc/1)

    default_name = printable_name(Reporters.default_reporter)
    default_id   = String.downcase(default_name)

    """
    # Dogma Reporters

    You can pass a reporter to the mix task using the `--format` flag.

    ```
    > mix dogma --format=flycheck

    lib/dogma/rules.ex:23:1: W: Blank lines detected at end of file
    test/dogma/reporters_test.exs:9:1: W: Trailing whitespace detected
    ```

    The default reporter is [#{default_name}](##{default_id}).

    ## Contents

    #{contents(reporters)}

    ---

    #{moduledoc(reporters)}

    """
  end

  defp extract_doc({key, reporter}) do
    name = printable_name(reporter)
    {_, doc} = Code.get_docs(reporter, :moduledoc)

    {name, doc, key}
  end

  defp printable_name(module) do
    module
    |> Module.split
    |> List.last
  end

  defp contents(reporters) when is_list(reporters) do
    reporters
    |> Enum.map(&contents/1)
  end

  defp contents({name, _, _}) do
    id = String.downcase(name)
    """
    * [#{name}](##{id})
    """
  end

  defp moduledoc(reporters) when is_list(reporters) do
    reporters
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
