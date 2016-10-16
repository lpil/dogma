use Dogma.RuleBuilder

defrule Dogma.Rule.DebuggerStatement do
  @moduledoc """
  A rule that disallows calls to `IEx.pry`.

  This is because we don't want debugger breakpoints accidentally being
  committed into our codebase.
  """

  def test(_rule, script) do
    script |> Script.walk( &check_ast(&1, &2) )
  end

  defp check_ast({:., m, [{:__aliases__, _, [:IEx]}, :pry]} = ast, errors) do
    error = error( m[:line] )
    {ast, [error | errors]}
  end
  defp check_ast(ast, errors) do
    {ast, errors}
  end

  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Possible forgotten debugger statement detected",
      line:    pos,
    }
  end
end
