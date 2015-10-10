defmodule Dogma.ScriptSources do
  @moduledoc """
  A module responsible for the identifying of Elixir source files to be
  analyised by Dogma.
  """

  alias Dogma.Script

  @ignored_dirs ~w(
    deps/
    _build/
  )

  @doc """
  Finds all Elixir source files in the given directory.

  The `exclude_patterns` argument is a list of regexes. File paths that match
  any of these regexes will not be returned.
  """
  def find(dir_path, exclude_patterns \\ []) when is_list exclude_patterns do
    dir_path
    |> to_string # Convert nil to ""
    |> Path.join( "**/*.{ex,exs}" )
    |> Path.wildcard
    |> Enum.reject( &String.starts_with?(&1, @ignored_dirs) )
    |> Enum.reject( &match_any?(&1, exclude_patterns) )
  end

  @doc """
  Takes a collection of paths to Elixir source files, and returns list of
  Script structs representing said source files.
  """
  def to_scripts(paths) when is_list paths do
    for path <- paths do
      path
      |> File.read!
      |> Script.parse( path )
    end
  end


  defp match_any?(string, regexes) do
    regexes
    |> Enum.any?(fn regex ->
      Regex.match?( regex, string )
    end)
  end
end
