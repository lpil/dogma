ExUnit.start()

defmodule DogmaTest.Helper do
  def pending do
    [:yellow, "PENDING"]
    |> IO.ANSI.format
    |> IO.write
  end
end
