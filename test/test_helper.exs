ExUnit.start(formatters: [ShouldI.CLIFormatter])

defmodule DogmaTest.Helper do
  def pending do
    [:yellow, "P"]
    |> IO.ANSI.format
    |> IO.write
  end
end
