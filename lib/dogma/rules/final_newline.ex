defmodule Dogma.Rules.FinalNewline do
  @moduledoc """
  A rule that disallows files that don't end with a final newline.
  """

  @behaviour Dogma.Rule

  alias Dogma.Error

  def test(script) do
    if script.source |> String.ends_with?("\n") do
      []
    else
      [ script |> error ]
    end
  end

  defp error(script) do
    %Error{
      rule:     __MODULE__,
      message:  "End of file newline missing",
      position: length( script.lines ),
    }
  end
end
