defmodule Dogma.Rules.FunctionName do
  @moduledoc """
  A rule that disallows function names not in snake_case
  """

  alias Dogma.Script
  alias Dogma.Error
  alias Dogma.Util.Name

  def test(script, _config \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end


  defp check_node({:def, _, [{name, meta, _}|_]} = node, errors) do
    check_function(name, meta, node, errors)
  end
  defp check_node({:defp, _, [{name, meta, _}|_]} = node, errors) do
    check_function(name, meta, node, errors)
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  defp check_function(name, meta, node, errors) do
    if name |> to_string |> Name.probably_snake_case? do
      {node, errors}
    else
      {node, [error( meta[:line] ) | errors]}
    end
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Function names should be in snake_case",
      position: pos,
    }
  end
end
