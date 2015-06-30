defmodule Dogma do
  alias Dogma.Script
  alias Dogma.Formatter

  def run(dir_path \\ "") do
    get_scripts(dir_path)
    |> Formatter.start( Formatter.Simple )
    |> test_scripts( Formatter.Simple )
    |> Formatter.finish( Formatter.Simple )
  end


  defp get_scripts(dir_path) do
    Path.wildcard( dir_path <> "**/*.{ex,exs}" )
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

  defp test_scripts(scripts, formatter) do
    for script <- scripts do
      script
      |> Script.run_tests
      |> Formatter.script( formatter )
    end
  end
end
