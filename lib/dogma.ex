defmodule Dogma do
  @moduledoc """
  Welcome to Dogma.

  This module is our entry point, and provides the `run/1` function through
  which you can run the tests on your current working directory.
  """


  alias Dogma.Script
  alias Dogma.Formatter

  def run(dir_path \\ "", rule_set \\ nil) do
    dir_path
    |> find_source_paths
    |> paths_to_scripts
    |> Formatter.start( Formatter.Simple )
    |> test_scripts( Formatter.Simple, rule_set)
    |> Formatter.finish( Formatter.Simple )
  end


  def test_scripts(scripts, formatter, rule_set) do
    for script <- scripts do
      script
      |> Script.run_tests( rule_set )
      |> Formatter.script( formatter )
    end
  end


  defp find_source_paths(dir_path) do
    Path.wildcard( dir_path <> "**/*.{ex,exs}" )
    |> Enum.reject( &String.starts_with?(&1, "deps/") )
  end

  defp paths_to_scripts(paths) do
    for path <- paths do
      path
      |> File.read!
      |> Script.parse( path )
    end
  end
end
