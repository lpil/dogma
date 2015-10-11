defmodule Dogma.Rule.InterpolationOnlyString do
  @moduledoc """
  A rule that disallows strings which are entirely the result of an
  interpolation.

  Good:

        output = inspect(self)

  Bad:

        output = "#\{inspect self}"
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script, _config \\ []) do
    script
    |> Script.walk(&check_node(&1, &2))
  end

  defp check_node({:<<>>, meta, [{:::, _, _}]} = node, errors) do
    {node, [ error(meta[:line]) | errors ]}
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Useless string interpolation detected.",
      line:    pos,
    }
  end
end
