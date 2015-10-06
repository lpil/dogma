defmodule Dogma.Rule.NegatedAssert do
  @moduledoc """
  A rule that disallows the use of an assert or refute with a negated
  argument. If you do this, swap the `assert` for an `refute`, or vice versa.

  These are considered valid:

      assert foo
      refute bar

  These are considered invalid:

      assert ! foo
      refute ! bar
      assert not foo
      refute not bar
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:assert, [line: i], [{:not, _, _} | _]} = node, errors) do
    err = error( :assert, i )
    {node, [err | errors]}
  end
  defp check_node({:assert, [line: i], [{:!, _, _} | _]} = node, errors) do
    err = error( :assert, i )
    {node, [err | errors]}
  end

  defp check_node({:refute, [line: i], [{:not, _, _} | _]} = node, errors) do
    err = error( :refute, i )
    {node, [err | errors]}
  end
  defp check_node({:refute, [line: i], [{:!, _, _} | _]} = node, errors) do
    err = error( :refute, i )
    {node, [err | errors]}
  end

  defp check_node(node, errors) do
    {node, errors}
  end


  defp error(:refute, line) do
    %Error{
      rule: __MODULE__,
      message: "Favour assert over a negated refute",
      line: Script.line(line),
    }
  end
  defp error(:assert, line) do
    %Error{
      rule: __MODULE__,
      message: "Favour refute over a negated assert",
      line: Script.line(line),
    }
  end
end
