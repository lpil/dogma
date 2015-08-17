defmodule Dogma.Formatter.Null do
  @moduledoc """
  A formatter that prints nothing. Ever.
  """

  @behaviour Dogma.Formatter

  @doc """
  Runs at the start of the test suite, printing nothing.
  """
  def start(_) do
  end

  @doc """
  Runs after each script is tested, printing nothing.
  """
  def script(_) do
  end

  @doc """
  Runs at the end of the test suite, printing nothing (predictably).
  """
  def finish(_) do
  end
end
