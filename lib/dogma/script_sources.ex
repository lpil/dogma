defmodule Dogma.ScriptSources do
  @moduledoc """
  A module responsible for the identifying of Elixir source files to be
  analyised by Dogma.
  """

  alias Dogma.Script

  @doc """
  Finds all Elixir source files in the given directory.

  In future we will want to handle ignored and added files from the mix config.
  """
  def find(dir_path) do
    dir_path
    |> to_string # Convert nil to ""
    |> Path.join( "**/*.{ex,exs}" )
    |> Path.wildcard
    |> Enum.reject( &String.starts_with?(&1, "deps/") )
  end

  @doc """
  Takes a collection of paths to Elixir source files, and returns list of
  Script structs representing said source files. 
  """
  def to_scripts(paths) do
    for path <- paths do
      path
      |> File.read!
      |> Script.parse( path )
    end
  end
end
