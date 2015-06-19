defmodule Dogma do
  alias Dogma.Script

  def run do
    paths = Path.wildcard( "**/*.{ex,exs}" )
    for path <- paths do
      path |> File.read! |> Script.parse( path ) |> Script.test_all
    end
  end
end
