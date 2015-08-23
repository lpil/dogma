defmodule Dogma.Error do
  @moduledoc """
  This module provides the struct we use to represent errors found in a file by
  Rules. These `%Errors` are to be passed to and reported by a formatter.
  """

  defstruct rule:    nil,
            message: nil,
            line:    nil
end
