defmodule Dogma.Reporter.Flycheck do
  @moduledoc """
  A machine-readable format suitable for integration with tools like
  [Flycheck](https://github.com/flycheck/flycheck) or
  [Syntastic](https://github.com/scrooloose/syntastic).

      /project/lib/test.ex:1:1: W: Module with out a @moduledoc detected
      /project/lib/test.ex:14:1: W: Comparison to a boolean is pointless
  """

  use GenEvent

  def handle_event({:finished, scripts}, _) do
    IO.write finish(scripts)
    {:ok, []}
  end

  def handle_event(_,_), do: {:ok, []}

  alias Dogma.Script

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
