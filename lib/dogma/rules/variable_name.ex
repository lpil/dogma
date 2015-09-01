defmodule Dogma.Rules.VariableName do
  @moduledoc """
  A rule that disallows variable names not in `snake_case`.

  `snake_case` is when only lowercase letters are used, and words are separated
  with underscores, rather than spaces.

  For example, this rule considers this variable assignment valid:

      my_mood = :happy

  But it considers this one invalid:

      myMood = :sad
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error
  alias Dogma.Util.Name

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:=, meta, [lhs|_]} = node, errors) do
    if variable_names_are_snake_case?(lhs) do
      {node, errors}
    else
      {node, [error( meta[:line] ) | errors]}
    end
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  for fun <- [:{}, :%{}, :^, :|] do
    defp variable_names_are_snake_case?({unquote(fun),_,value}) do
      variable_names_are_snake_case?(value)
    end
  end
  defp variable_names_are_snake_case?(lhs) when is_list(lhs) do
    lhs |> Enum.all?(&variable_names_are_snake_case?/1)
  end
  defp variable_names_are_snake_case?({l,r}) do
    variable_names_are_snake_case?([l,r])
  end
  defp variable_names_are_snake_case?({name,_,_}) do
    name |> to_string |> Name.probably_snake_case?
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
