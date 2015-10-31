ExUnit.start(formatters: [ShouldI.CLIFormatter])

defmodule DogmaTest.Helper do
  def pending do
    [:yellow, "PENDING"]
    |> IO.ANSI.format
    |> IO.write
  end
end
