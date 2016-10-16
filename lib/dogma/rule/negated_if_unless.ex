use Dogma.RuleBuilder

defrule Dogma.Rule.NegatedIfUnless do
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

  def test(_rule, script) do
    script |> Script.walk( &check_ast(&1, &2) )
  end

  defp check_ast({:if, [line: i], [{:not, _, _}, _]} = ast, errors) do
    err = error( :if, i )
    {ast, [err | errors]}
  end
  defp check_ast({:if, [line: i], [{:!, _, _}, _]} = ast, errors) do
    err = error( :if, i )
    {ast, [err | errors]}
  end

  defp check_ast({:unless, [line: i], [{:not, _, _}, _]} = ast, errors) do
    err = error( :unless, i )
    {ast, [err | errors]}
  end
  defp check_ast({:unless, [line: i], [{:!, _, _}, _]} = ast, errors) do
    err = error( :unless, i )
    {ast, [err | errors]}
  end

  defp check_ast(ast, errors) do
    {ast, errors}
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
