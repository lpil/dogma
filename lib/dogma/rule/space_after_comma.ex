use Dogma.RuleBuilder

defrule Dogma.Rule.SpaceAfterComma, [spaces: 1] do
  @moduledoc """
  A rule that enforces to use at least `spaces` after comma.

  This rule can be configured with the `spaces` option, which allows you to
  specify your own number of spaces after comma.

  Commas in comments are not checked by this rule.
  """
  @spaces_pattern ~r/\,(\s*).+/
  @comment_pattern ~r/#.*\z/

  def test(rule, script) do
    script.processed_lines
    |> Enum.map(&strip_comments/1)
    |> Enum.filter(fn line -> check_line(rule, line) end)
    |> Enum.map(fn line ->  error(rule, line) end)
  end

  defp strip_comments({pos, line}) do
    line_without_comments = Regex.replace(@comment_pattern, line, "")
    {pos, line_without_comments}
  end

  defp check_line(rule, {_, line}) do
    @spaces_pattern
    |> Regex.scan(line)
    |> Enum.any?(fn [_, group] ->
      String.length(group) < rule.spaces
    end)
  end

  defp error(rule, {pos, _}) do
    %Error{
      rule:     __MODULE__,
      message:  "Should be #{rule.spaces} spaces after comma",
      line:     Dogma.Script.line(pos),
    }
  end
end
