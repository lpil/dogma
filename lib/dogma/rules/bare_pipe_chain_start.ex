defmodule Dogma.Rules.BarePipeChainStart do
  @moduledoc """
  A rule that enforces that function chains always begin with a bare value.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script, _list),
  do: test(script)

  def test(script) do
    script
    |> Script.walk(&check_node/2)
    |> Enum.reverse
  end

  defp check_node({:|>, _, [lhs, _]}, errors) do
    case function_line(lhs) do
      {:ok, line} -> {node, [error(line) | errors]}
      _           -> {node, errors}
    end
  end

  defp check_node(node, errors) do
    {node, errors}
  end

  defp function_line({:|>, _, [lhs, _]}),
  do: function_line(lhs)

  # exception for map keys
  defp function_line({{:., _, _}, _, []}),
  do: nil

  # exception for bare maps
  defp function_line({:%, _, _}),
  do: nil

  # exception for structs
  defp function_line({:%{}, _, _}),
  do: nil

  # exception for large tuples (size > 2)
  defp function_line({:{}, _, _}),
  do: nil

  # exception for module attributes
  defp function_line({:@, _, _}),
  do: nil

  defp function_line({atom, meta, args})
  when is_atom(atom) and is_list(args) do
    if atom |> to_string |> String.starts_with?("sigil") do
      nil # exception for sigils
    else
      {:ok, meta[:line]}
    end
  end

  defp function_line({{:., meta, _}, _, _}),
  do: {:ok, meta[:line]}

  defp function_line(_),
  do: nil

  defp error(line) do
    %Error{
      rule:    __MODULE__,
      message: "Function Pipe Chains must start with a bare value",
      line:    line
    }
  end
end
