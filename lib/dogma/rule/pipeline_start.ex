defmodule Dogma.Rule.PipelineStart do
  @moduledoc """
  A rule that enforces that function chains always begin with a bare value,
  rather than a function call with arguments.

  For example, this is considered valid:

      "Hello World"
      |> String.split("")
      |> Enum.reverse
      |> Enum.join

  While this is not:

      String.split("Hello World", "")
      |> Enum.reverse
      |> Enum.join
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
      {:error, line} ->
        {node, [error(line) | errors]}

      _ ->
        {node, errors}
    end
  end

  defp check_node(node, errors) do
    {node, errors}
  end

  defp function_line({:|>, _, [lhs, _]}),
  do: function_line(lhs)

  # exception for map.key
  defp function_line({{:., _, _}, _, []}),
  do: :ok

  # exception for map[key]
  defp function_line({{:., _, [Access, :get]}, _, _}),
  do: :ok

  # exception for bare maps
  defp function_line({:%, _, _}),
  do: :ok

  # exception for structs
  defp function_line({:%{}, _, _}),
  do: :ok

  # exception for large tuples (size > 2)
  defp function_line({:{}, _, _}),
  do: :ok

  # exception for module attributes
  defp function_line({:@, _, _}),
  do: :ok

  # exception for module atoms
  defp function_line({:__aliases__, _, _}),
  do: :ok

  # exception for binaries
  defp function_line({:<<>>, _, _}),
  do: :ok

  # exception for ranges
  defp function_line({:.., _, _}),
  do: :ok

  # exception for unquote
  defp function_line({:unquote, _, _}),
  do: :ok

  defp function_line({atom, meta, args})
  when is_atom(atom) and is_list(args) do
    if atom |> to_string |> String.starts_with?("sigil") do
      :ok # exception for sigils
    else
      {:error, meta[:line]}
    end
  end

  defp function_line({{:., meta, _}, _, _}),
  do: {:error, meta[:line]}

  defp function_line(_),
  do: :ok

  defp error(line) do
    %Error{
      rule:    __MODULE__,
      message: "Function Pipe Chains must start with a bare value",
      line:    line
    }
  end
end
