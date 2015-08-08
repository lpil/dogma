defmodule Dogma.Rules.FinalNewline do
  @moduledoc """
  A rule that disallows files that don't end with a final newline.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    if script.source |> String.ends_with?("\n") do
      script
    else
      script |> add_error
    end
  end

  defp add_error(script) do
    error = %Error{
      rule:     __MODULE__,
      message:  "End of file newline missing",
      position: length( script.lines ),
    }
    script |> Script.register_error( error )
  end
end
