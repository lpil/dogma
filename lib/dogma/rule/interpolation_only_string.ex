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
    |> Script.walk(&check_node(&1, &2))
  end

  defp check_node(
    {:<<>>, meta, [{:::, _, [{{:., _, call}, _, _}, _]} ]} = node, errors
  ) when call == [Kernel, :to_string]
  do
    {node, [ error(meta[:line]) | errors ]}
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Useless string interpolation detected.",
      line:    pos,
    }
  end
end
