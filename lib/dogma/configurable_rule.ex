defmodule Dogma.ConfigurableRule do
  @moduledoc """
  The ConfigurableRule behaviour, used to assert the interface used by the Rule
  modules that allow for additional configuration to be provided.
  """

  alias Dogma.Script

  use Behaviour

  @doc """
  A function that takes a Script struct and a list of key value pairs as
  configuration. Then tests the script to see if it violates
  the rule, and returns the script with any errors prepended to the struct's
  errors field.
  """
  defcallback test(%Script{}, List) :: %Script{}
end
