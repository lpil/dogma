defmodule Dogma.Rule.NegatedIfUnless do
  @moduledoc """
  A rule that disallows the use of an if or unless with a negated predicate.
  If you do this, swap the `if` for an `unless`, or vice versa.

  These are considered valid:

      if happy? do
        party()
      end
      unless sad? do
        jump_up()
      end

  These are considered invalid:

      if !happy? do
        stay_in_bed()
      end
      unless not sad? do
        mope_about()
      end
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:if, [line: i], [{:not, _, _}, _]} = node, errors) do
    err = error( :if, i )
    {node, [err | errors]}
  end
  defp check_node({:if, [line: i], [{:!, _, _}, _]} = node, errors) do
    err = error( :if, i )
    {node, [err | errors]}
  end

  defp check_node({:unless, [line: i], [{:not, _, _}, _]} = node, errors) do
    err = error( :unless, i )
    {node, [err | errors]}
  end
  defp check_node({:unless, [line: i], [{:!, _, _}, _]} = node, errors) do
    err = error( :unless, i )
    {node, [err | errors]}
  end

  defp check_node(node, errors) do
    {node, errors}
  end


  defp error(:unless, line) do
    %Error{
      rule: __MODULE__,
      message: "Favour if over a negated unless",
      line: Dogma.Script.line(line),
    }
  end
  defp error(:if, line) do
    %Error{
      rule: __MODULE__,
      message: "Favour unless over a negated if",
      line: Dogma.Script.line(line),
    }
  end
end
