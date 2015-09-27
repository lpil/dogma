defmodule Dogma.Rule.FunctionArity do
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

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script), do: test(script, [])

  def test(script, _config = []) do
    test(script, max: 4)
  end

  def test(script, max: max) do
    script
    |> Script.walk(fn node, errs ->
      check_node(node, errs, max)
    end)
  end

  @defs ~w(def defp defmacro)a
  for type <- @defs do

    defp check_node({unquote(type), _, _} = node, errors, max) do
      {name, line, args} = get_fun_details(node)
      arity = args |> length
      if arity > max do
        {node, [error(line, name, max, arity) | errors]}
      else
        {node, errors}
      end
    end

  end

  defp check_node(node, errors, _) do
    {node, errors}
  end

  defp get_fun_details(node) do
    {_, [line: line], details} = node
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
