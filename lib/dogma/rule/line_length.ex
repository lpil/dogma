use Dogma.RuleBuilder

defrule Dogma.Rule.LineLength, [max_length: 80] do
  @moduledoc """
  A rule that disallows lines longer than X characters in length (defaults to
  80).

  This rule can be configured with the `max_length` option, which allows you to
  specify your own line max character count.
  """

  def test(rule, script) do
    script.lines
    |> Enum.filter(&longer_than(&1, rule.max_length))
    |> Enum.map(&error(&1, rule.max_length))
  end


  defp longer_than({_, line}, max) do
    String.length(line) > max
  end

  defp error({pos, line}, max) do
    len = String.length(line)
    %Error{
      rule:     __MODULE__,
      message:  "Line length should not exceed #{max} chars (was #{len}).",
      line: Dogma.Script.line(pos),
    }
  end
end
