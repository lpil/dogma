use Dogma.RuleBuilder

defrule Dogma.Rule.ModuleAttributeName do
  @moduledoc """
  A rule that disallows module attribute names not in snake_case
  """

  alias Dogma.Util.Name

  def test(_rule, script) do
    script |> Script.walk( &check_ast(&1, &2) )
  end

  defp check_ast({:@, meta, [{name, _, _}]} = ast, errors) do
    errors = if name |> to_string |> Name.not_snake_case? do
      [error( meta[:line] ) | errors]
    else
      errors
    end
    {ast, errors}
  end
  defp check_ast(ast, errors) do
    {ast, errors}
  end


  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Module attribute names should be in snake_case",
      line: Dogma.Script.line(pos),
    }
  end
end
