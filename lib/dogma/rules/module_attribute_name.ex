defmodule Dogma.Rules.ModuleAttributeName do
  @moduledoc """
  A rule that disallows module attribute names not in snake_case
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error
  alias Dogma.Util.Name

  def test(script) do
    script |> Script.walk( &check_node(&1, &2) )
  end


  defp check_node({:@, meta, [{name, _, _}]} = node, errors) do
    if name |> to_string |> Name.probably_not_snake_case? do
      errors = [error( meta[:line] ) | errors]
    end
    {node, errors}
  end
  defp check_node(node, errors) do
    {node, errors}
  end


  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Module attribute names should be in snake_case",
      position: pos,
    }
  end
end
