defmodule Dogma.Rule do
  @moduledoc """
  The Rule behaviour, used to assert the interface used by our Rule modules.
  """

  alias Dogma.Script

  use Behaviour

  @doc """
  A function that takes a Script struct, tests the script to see if it violates
  the rule, and returns a list of errors.
  """
  defcallback test(%Script{}) :: []
end
