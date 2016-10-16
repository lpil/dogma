use Dogma.RuleBuilder

defrule Dogma.Rule.FunctionArity, max: 4 do
  @moduledoc """
  A rule that disallows functions and macros with arity greater than 4, meaning
  a function may not take more than 4 arguments.

  By default this function is considered invalid by this rule:

      def transform(a, b, c, d, e) do
        # Do something
      end

  The maximum allowed arity for this rule can be configured with the `max`
  option in your mix config.
  """

  alias Dogma.Script
  alias Dogma.Error

  def test(rule, script) do
    Script.walk(script, &check_ast(&1, &2, rule.max))
  end

  @defs ~w(def defp defmacro)a
  for type <- @defs do
    defp check_ast({unquote(type), _, nil} = ast, errors, _) do
      {ast, errors}
    end

    defp check_ast({unquote(type), _, _} = ast, errors, max) do
      {name, line, args} = get_fun_details(ast)
      arity = args |> length
      if arity > max do
        {ast, [error(line, name, max, arity) | errors]}
      else
        {ast, errors}
      end
    end

  end

  defp check_ast(ast, errors, _) do
    {ast, errors}
  end

  defp get_fun_details(ast) do
    {_, [line: line], details} = ast
    {name, _, args} = hd( details )
    args = args || []
    {name, line, args}
  end

  defp error(pos, name, max, arity) do
    %Error{
      rule:    __MODULE__,
      message: "Arity of `#{name}` should be less than #{max} (was #{arity}).",
      line: Dogma.Script.line(pos),
    }
  end
end
