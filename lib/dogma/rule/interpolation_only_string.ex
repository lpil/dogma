use Dogma.RuleBuilder

defrule Dogma.Rule.InterpolationOnlyString do
  @moduledoc """
  A rule that disallows strings which are entirely the result of an
  interpolation.

  Good:

     output = inspect(self)

  Bad:

      output = "#\{inspect self}"
  """

  def test(_rule, script) do
    script
    |> Script.walk(&check_ast(&1, &2))
  end


  defp check_ast({:sigil_r, _, _}, errors) do
    {[], errors}
  end

  defp check_ast(
    {:<<>>, meta, [{:::, _, [{{:., _, call}, _, _}, _]} ]} = ast,
    errors
  ) when call == [Kernel, :to_string]
  do
    {ast, [ error(meta[:line]) | errors ]}
  end

  defp check_ast(ast, errors) do
    {ast, errors}
  end


  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Useless string interpolation detected.",
      line:    pos,
    }
  end
end
