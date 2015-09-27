defmodule Dogma.Rule.UnlessElse do
  @moduledoc """
  A rule that disallows the use of an `else` block with the `unless` macro.

  For example, the rule considers these valid:

      unless something do
        :ok
      end

      if something do
        :one
      else
        :two
      end

  But it considers this one invalid as it is an `unless` with an `else`:

      unless something do
        :one
      else
        :two
      end

  The solution is to swap the order of the blocks, and change the `unless` to
  an `if`, so the previous invalid example would become this:

      if something do
        :two
      else
        :one
      end
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:unless, [line: i], [_, [do: _, else: _]]} = node, errs) do
    err = error( i )
    {node, [err | errs]}
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Favour if over unless with else",
      line: Dogma.Script.line(pos),
    }
  end
end
