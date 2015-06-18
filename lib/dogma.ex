defmodule Dogma do
  alias Dogma.Script
  alias Dogma.Rules

  def run do
    paths = Path.wildcard( "**/*.{ex,exs}" )
    for path <- paths do
      path |> File.read! |> Script.parse( path ) |> test_script
    end
  end

  def test_script(script) do
    List.foldl(
      Rules.list,
      script,
      fn(rule, x) -> rule.test x end
    )
  end
end
