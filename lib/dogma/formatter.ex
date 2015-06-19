defmodule Dogma.Formatter do
  @moduledoc """
  Handles formatters. In short, decides whether we should print to STDIO.
  """

  @doc """
  Runs at the start of the test suite.
  """
  def start(files, formatter) do
    IO.write formatter.start( files )
    files
  end

  @doc """
  Runs after each script is tested.
  """
  def script(script, formatter) do
    IO.write formatter.script( script )
    script
  end

  @doc """
  Runs at the end of the test suite.
  """
  def finish(files, formatter) do
    IO.write formatter.finish( files )
    files
  end
end
