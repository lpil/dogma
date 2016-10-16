use Dogma.RuleBuilder

defrule Dogma.Rule.NegatedAssert do
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

  def test(_rule, script) do
    script |> Script.walk( &check_ast(&1, &2) )
  end

  defp check_ast({:assert, [line: i], [{:not, _, _} | _]} = ast, errors) do
    err = error( :assert, i )
    {ast, [err | errors]}
  end
  defp check_ast({:assert, [line: i], [{:!, _, _} | _]} = ast, errors) do
    err = error( :assert, i )
    {ast, [err | errors]}
  end

  defp check_ast({:refute, [line: i], [{:not, _, _} | _]} = ast, errors) do
    err = error( :refute, i )
    {ast, [err | errors]}
  end
  defp check_ast({:refute, [line: i], [{:!, _, _} | _]} = ast, errors) do
    err = error( :refute, i )
    {ast, [err | errors]}
  end

  defp check_ast(ast, errors) do
    {ast, errors}
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
