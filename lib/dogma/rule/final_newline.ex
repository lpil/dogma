use Dogma.RuleBuilder

defrule Dogma.Rule.FinalNewline do
  @moduledoc """
  A rule that disallows files that don't end with a final newline.
  """

  alias Dogma.Error

  def test(_rule, script) do
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
      line: length( script.lines ),
    }
  end
end
