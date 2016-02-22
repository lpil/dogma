use Dogma.RuleBuilder

defrule Dogma.Rule.SpaceAfterComma, [spaces: 1] do
  @moduledoc """
  A rule that enforces to use `spaces` after comma.

  This rule can be configured with the `spaces` option, which allows you to
  specify your own number of spaces after comma.
  """
  @spaces_pattern ~r/\,(\s*).+/

  def test(rule, script) do
    script.lines
    |> Enum.map(&drop_strings/1)
    |> Enum.filter(fn line -> check_line(rule, line) end)
    |> Enum.map(fn line ->  error(rule, line) end)
  end

  defp check_line(rule, {_, line}) do
    @spaces_pattern
    |> Regex.scan(line)
    |> Enum.any?(fn [_, group] ->
      String.length(group) != rule.spaces
    end)
  end

  defp drop_strings({pos, line}) do
    {pos, Regex.replace(~r/\"(.*?)\"/, line, "\"\"")}
  end

  defp error(rule, {pos, _}) do
    %Error{
      rule:     __MODULE__,
      message:  "Should be #{rule.spaces} spaces after comma",
      line:     Dogma.Script.line(pos),
    }
  end
end
