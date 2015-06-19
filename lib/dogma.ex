defmodule Dogma do
  alias Dogma.Script
  alias Dogma.Formatter

  def run do
    get_scripts
    |> Formatter.start( Formatter.Simple )
    |> test_scripts
    |> Formatter.finish( Formatter.Simple )
  end


  defp get_scripts do
    Path.wildcard( "**/*.{ex,exs}" )
    |> Enum.reject( &String.starts_with?(&1, "deps/") )
    |> read_paths
  end

  defp read_paths(paths) do
    for path <- paths do
      path
      |> File.read!
      |> Script.parse( path )
    end
  end

  defp test_scripts(scripts) do
    for script <- scripts do
      script
      |> Script.run_tests
      |> Formatter.script( Formatter.Simple )
    end
  end
end
