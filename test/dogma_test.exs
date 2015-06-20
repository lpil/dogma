defmodule DogmaTest do
  use ShouldI

  def pending do
    IO.ANSI.format( [:yellow, "P"] )
    |> IO.write
  end
end
