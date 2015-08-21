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
    Path.wildcard( dir_path <> "**/*.{ex,exs}" )
    |> Enum.reject( &String.starts_with?(&1, "deps/") )
  end

  def to_scripts(paths) do
    for path <- paths do
      path
      |> File.read!
      |> Script.parse( path )
    end
  end
end
