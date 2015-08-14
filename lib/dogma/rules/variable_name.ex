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

  defp check_node({:=, _, [{name, meta, _}|_]} = node, errors) do
    if name |> to_string |> Name.probably_snake_case? do
      {node, errors}
    else
      {node, [error( meta[:line] ) | errors]}
    end
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Variable names should be in snake_case",
      line:    pos,
    }
  end
end
