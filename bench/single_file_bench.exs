defmodule Dogma.SingleSourceBench do
  use Benchfella

  alias Dogma.Script
  alias Dogma.Formatter

  @script """
  defmodule Subject do
    @moduledoc "Hello!"

    def dance do
      "Disco disco."
    end

    @doc "What's up?"
    def camelCase do
      true == true
    end
  end
  """ |> Script.parse("foo.exs")

  bench "Run all Rules on single source" do
    @script
    |> List.wrap
    |> Dogma.test_scripts( Formatter.Null, nil )
  end
end
