defmodule Dogma.Rule.InfixOperatorSpaces do
  @moduledoc """
  A rule that ensures infix operators are surrounded by spaces.

  For example, it considers the following expressions valid:

      foo = bar

      foo + bar

      foo <= bar

      foo || bar

  But it considers these invalid:

      foo=bar

      foo+bar

      foo<=bar

      foo||bar
  """

  @behaviour Dogma.Rule

  alias Dogma.Error

  @operators [:dual_op, :mult_op, :match_op, :rel_op, :and_op, :or_op,
    :comp_op, :two_op, :assoc_op]

  def test(script, _config = [] \\ []) do
    script.tokens |> operator_positions |> check_infix_spaces(script.lines)
  end

  defp operator_positions(tokens, acc \\ [])

  defp operator_positions([], acc) do
    Enum.reverse(acc)
  end

  defp operator_positions([{token, position, _} | rest], acc)
  when token in @operators do
    operator_positions(rest, [position | acc])
  end

  defp operator_positions([_ | rest], acc) do
    operator_positions(rest, acc)
  end

  defp check_infix_spaces(positions, lines, acc \\ [])

  defp check_infix_spaces(positions, lines, acc)
  when positions == [] or lines == [] do
    Enum.reverse(acc)
  end

  defp check_infix_spaces(positions, lines, acc) do
    {pline, start, finish} = hd(positions)
    {line, text} = hd(lines)

    cond do
      pline > line ->
        check_infix_spaces(positions, tl(lines), acc)
      pline < line ->
        check_infix_spaces(tl(positions), lines, acc)
      valid_operator_spaces(text, start, finish) ->
        check_infix_spaces(tl(positions), lines, acc)
      true ->
        check_infix_spaces(tl(positions), tl(lines), [error(line) | acc])
    end
  end

  defp valid_operator_spaces(text, start, finish) do
    char_before = String.slice(text, start - 2..start - 2)
    char_after = String.slice(text, finish - 1..finish - 1)
    char_before == " " && (finish > String.length(text) || char_after == " ")
  end

  defp error(line) do
    %Error{
      rule:    __MODULE__,
      message: "Infix operators should be surrounded by whitespace.",
      line:    line,
    }
  end

end
