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

  defp check_node({:=, meta, [lhs|rhs]} = node, errors) do
    if [lhs, rhs] |> Enum.all?(&variable_names_are_snake_case?/1) do
      {node, errors}
    else
      {node, [error( meta[:line] ) | errors]}
    end
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  for fun <- [:{}, :%{}, :^, :|, :|>, :<>, :%] do
    defp variable_names_are_snake_case?({unquote(fun),_,value}) do
      variable_names_are_snake_case?(value)
    end
  end
  defp variable_names_are_snake_case?({:__aliases__,_,_}), do: true
  defp variable_names_are_snake_case?({{:.,_,_}, _, _}), do: true
  defp variable_names_are_snake_case?(lhs) when is_list(lhs) do
    lhs |> Enum.all?(&variable_names_are_snake_case?/1)
  end
  defp variable_names_are_snake_case?({l,r}) do
    variable_names_are_snake_case?([l,r])
  end
  defp variable_names_are_snake_case?({name,_,_}) when is_atom(name) do
    name = name |> to_string
    cond do
      name |> String.starts_with?("sigil_") -> true
      name |> String.match?(~r/^[a-z]/i) -> name |> Name.snake_case?
      true -> true
    end
  end
  defp variable_names_are_snake_case?(_), do: true

  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Variable names should be in snake_case",
      line:    pos,
    }
  end
end
