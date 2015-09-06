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


  @default_formatter Dogma.Formatter.Simple

  @doc """
  Runs at the start of the test suite.
  """
  def start(files, formatter \\ @default_formatter) do
    IO.write formatter.start( files )
    files
  end

  @doc """
  Runs after each script is tested. Useful for progress indicators.
  """
  def script(script, formatter \\ @default_formatter) do
    IO.write formatter.script( script )
    script
  end

  @doc """
  Runs at the end of the test suite.
  """
  def finish(files, formatter \\ @default_formatter) do
    IO.write formatter.finish( files )
    files
  end

  @doc """
  Returns the default formatter
  """
  def default_formatter do
    @default_formatter
  end

  @doc """
  Returns formatters mapped to their option keys"
  """
  def formatters do
    %{
      "flycheck" => Dogma.Formatter.Flycheck,
      "json"     => Dogma.Formatter.JSON,
      "null"     => Dogma.Formatter.Null,
      "simple"   => Dogma.Formatter.Simple,
    }
  end
end
