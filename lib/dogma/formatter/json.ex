defmodule Dogma.Formatter.JSON do
  @moduledoc """
  A machine readable format in JSON.

  The JSON structure is like the following example:

      {
        "metadata": {
          "dogma_version": "0.3.0",
          "elixir_version": "1.0.5",
          "erlang_version": "Erlang/OTP 10 [erts-7.0.3] [64-bit]",
          "system_architecture": "x86_64-apple-darwin14.5.0"
        },
        "files": [{
            "path": "lib/foo.ex",
            "errors": []
         }, {
            "path": "lib/bar.ex",
            "errors": [{
                "line": 1,
                "rule": "ModuleDoc",
                "message": "Module without @moduledoc detected"
             }, {
                "line": 14,
                "rule": "ComparisonToBoolean",
                "message": "Comparison to a boolean is useless"
             }
            ]
        }],
        "summary": {
          "error_count": 2,
          "inspected_file_count": 2
        }
      }
  """

  @behaviour Dogma.Formatter

  @doc """
  Runs at the start of the test suite, printing nothing.
  """
  def start(_), do: ""

  @doc """
  Runs after each script is tested, printing nothing.
  """
  def script(_), do: ""

  @doc """
  Runs at the end of the test suite, printing json.
  """
  def finish(scripts) do
    %{
      metadata: metadata,
      files: Enum.map(scripts, &format/1),
      summary: summary(scripts)
    } |> Poison.encode!
  end

  defp metadata do
    erl_version = :system_version
                  |> :erlang.system_info
                  |> to_string

    architecture = :system_architecture
                   |> :erlang.system_info
                   |> to_string

    %{
      dogma_version: Dogma.version,
      elixir_version: System.version,
      erlang_version: erl_version,
      system_architecture: architecture
    }
  end

  defp format(script) do
    %{
      path: script.path,
      errors: Enum.map(script.errors, &format_error/1)
    }
  end

  defp format_error(error) do
    %{
      line: error.line,
      rule: printable_name(error.rule),
      message: error.message
    }
  end

  defp printable_name(module) do
    module
    |> Module.split
    |> List.last
  end

  defp summary(scripts) do
    %{
      offense_count: count_errors(scripts),
      inspected_file_count: length(scripts)
    }
  end

  defp count_errors(scripts) do
    scripts
    |> Enum.map(&(&1.errors))
    |> List.flatten
    |> length
  end
end
