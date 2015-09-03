defmodule Dogma.Formatter.Flycheck do
  @moduledoc """
  A machine-readable format suitable for integration with tools like
  [Flycheck](https://github.com/flycheck/flycheck) or
  [Syntastic](https://github.com/scrooloose/syntastic).

      /project/lib/test.ex:1:1: W: Module with out a @moduledoc detected
      /project/lib/test.ex:14:1: W: Comparison to a boolean is pointless
  """

  @behaviour Dogma.Formatter

  alias Dogma.Script

  @doc """
  Runs at the start of the test suite, displaying nothing
  """
  def start(_scripts), do: ""

  @doc """
  Runs after each script is tested. Prints nothing.
  """
  def script(_script), do: ""

  @doc """
  Runs at the end of the test suite, displaying errors.
  """
  def finish(scripts) do
    errors = scripts
    |> format_errors
    |> Enum.join("\n")

    errors <> "\n"
  end

  defp format_errors(script = %Script{}) do
    script.errors
    |> Enum.map(&(format_error(&1, script.path)))
  end

  defp format_errors(scripts) do
    scripts
    |> Enum.map(&format_errors/1)
    |> List.flatten
  end

  defp format_error(error, script) do
    "#{script}:#{error.line}:1: W: #{error.message}"
  end
end
