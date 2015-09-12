defmodule Dogma.Corrections do
  @moduledoc """
  Responsible for running of the appropriate correction set on a given set
  of scripts with the appropriate configuration.
  """

  alias Dogma.Script

  @doc """
  Runs Script.repair asynchronously.  
  """
  def repair(scripts, false), do: scripts
  def repair(scripts, true) do
    scripts
      |> Enum.map(&Task.async(fn -> &1 |> Script.repair end))
      |> Enum.map(&Task.await/1)
  end
end
