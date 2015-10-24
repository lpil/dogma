defmodule Dogma.Rule.VariableName do
  @moduledoc """
  A rule that disallows variable names not in `snake_case`.

  `snake_case` is when only lowercase letters are used, and words are separated
  with underscores, rather than spaces.

  Good:

      my_mood = :happy
      [number_of_cats] = [3]
      {function_name, _, other_stuff} = node

  Bad:

      myMood = :sad
      [numberOfCats] = [3]
      {functionName, meta, otherStuff} = node
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error
  alias Dogma.Util.Name

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:=, _, nodes} = node, errors) do
    new_errors =
      nodes
      |> invalid_lines
      |> Enum.map( &error/1 )
    {node, new_errors ++ errors}
  end
  defp check_node(node, errors) do
    {node, errors}
  end


  defp invalid_lines(nodes) when is_list(nodes) do
    nodes
    |> Enum.map( &invalid_lines/1 )
    |> List.flatten
    |> Enum.filter(&(&1))
    |> Enum.reverse
  end
  for fun <- [:{}, :%{}, :^, :|, :|>, :<>, :%] do
    defp invalid_lines({unquote(fun), _, value}) do
      invalid_lines(value)
    end
  end
  defp invalid_lines({:__aliases__, _, _}), do: false
  defp invalid_lines({{:., _, _}, _, _}), do: false
  defp invalid_lines({l, r}) do
    invalid_lines([l, r])
  end
  defp invalid_lines({name, meta, _}) when is_atom(name) do
    if name |> to_string |> invalid_name? do
      meta[:line]
    else
      false
    end
  end
  defp invalid_lines(_), do: false


  defp invalid_name?(<< "sigil_" :: utf8, _ :: binary >>), do: false
  defp invalid_name?(name) do
    String.match?( name, ~r/\A[a-zA-Z]/) && (! Name.snake_case?( name ))
  end


  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Variable names should be in snake_case",
      line:    pos,
    }
  end
end
