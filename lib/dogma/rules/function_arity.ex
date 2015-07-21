defmodule Dogma.Rules.FunctionArity do
  @moduledoc """
  A rule that disallows functions with arity greater than 4 (configurable)
  """

  alias Dogma.Script
  alias Dogma.Error

  def test(script, options \\ []) do
    max = options |> Keyword.get(:max, 4)
    script
      |> Script.walk( fn(node, errs) -> check_node(node, errs, max) end)
  end

  defp check_node({:def, _, _} = node, errors, max_arity) do
    check_function(node, errors, max_arity)
  end
  defp check_node({:defp, _, _} = node, errors, max_arity) do
    check_function(node, errors, max_arity)
  end
  defp check_node(node, errors, _max_arity) do
    {node, errors}
  end

  defp check_function(node, errors, max_arity) do
    {_, [line: line_number], [{_, _, function_args}, _]} = node
    function_arity = Enum.count(function_args || [])
    if (function_arity > max_arity) do
      {node, [error(line_number, max_arity) | errors]}
    else
      {node, errors}
    end
  end

  defp error(line_number, max_arity) do
    %Error{
      rule:     __MODULE__,
      message:  "Function arity should be #{max_arity} or less",
      position: line_number,
    }
  end
end
