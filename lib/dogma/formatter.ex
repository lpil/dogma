defmodule Dogma.Formatter do
  @moduledoc """
  Handles formatters. In short, decides what we should print to STDOUT.

  Also provides the formatter behaviour.
  """

  use Behaviour
  alias Dogma.Script

  @doc """
  Formats the message to be printed at the start of the test suite.
  """
  defcallback start( [%Script{}] ) :: String.t

  @doc """
  Formats the message to be printed after each script has been tested.
  """
  defcallback script( [%Script{}] ) :: String.t

  @doc """
  Formats the message to be printed at the end of the test suite.
  """
  defcallback finish( [%Script{}] ) :: String.t



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
