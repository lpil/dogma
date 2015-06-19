defmodule Dogma.Formatter do
  @moduledoc """
  Handles formatters. In short, decides whether we should print to STDIO.
  """

  @doc """
  Runs at the start of the test suite.
  """
  def start(formatter, files) do
    IO.puts formatter.start( files )
  end

  @doc """
  Runs after each script is tested.
  """
  def script(formatter, script) do
    IO.puts formatter.script( script )
  end

  @doc """
  Runs at the end of the test suite.
  """
  def finish(formatter, files) do
    IO.puts formatter.finish( files )
  end
end
