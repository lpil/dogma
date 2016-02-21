use Dogma.RuleBuilder

defrule Dogma.Rule.SpaceAfterComma, [spaces: 1] do
  @moduledoc """
  A rule that enforces to use `spaces` after comma.

  This rule can be configured with the `spaces` option, which allows you to
  specify your own number of spaces after comma.
  """

  def test(rule, script) do
    []
  end

  defp error(rule, {pos, line}) do
    %Error{
      rule:     __MODULE__,
      message:  "Should be #{rule.spaces} spaces after comma",
      line: Dogma.Script.line(pos),
    }
  end
end
