defmodule Dogma.Reporters do
  @moduledoc """
  Lists available reporters.
  """

  @default_reporter Dogma.Reporter.Simple

  @doc """
  Returns the default reporter
  """
  def default_reporter do
    @default_reporter
  end

  @doc """
  Returns reporters mapped to their option keys"
  """
  def reporters do
    %{
      "flycheck" => Dogma.Reporter.Flycheck,
      "json"     => Dogma.Reporter.JSON,
      "simple"   => Dogma.Reporter.Simple,
    }
  end
end
