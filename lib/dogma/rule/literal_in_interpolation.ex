defmodule Dogma.Rule.LiteralInInterpolation do
  @moduledoc """
  A rule that disallows useless string interpolations
  that contain a literal value instead of a variable or function.
  Examples:

      "Hello #\{:jose}"
      "The are #\{4} cats."
      "Don't #\{~s(interpolate)} literals"
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  import Dogma.Util.AST, only: [literal?: 1]

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:::, meta, args} = node, errors) do
    case get_interpolated_token(args) do
      {:ok, token} ->
        if literal?(token) do
          {node, [error(meta[:line]) | errors]}
        else
          {node, errors}
        end
       _ -> {node, errors}
    end
  end

  defp check_node(node, errors) do
    {node, errors}
  end

  defp get_interpolated_token(args) do
    case args do
      [{{:., _, [Kernel, :to_string]}, _,
        [interpolated_token]},
        {:binary, _, _}] -> {:ok, interpolated_token}
      _ -> {:error, nil}
    end
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Literal value found in interpolation",
      line: Dogma.Script.line(pos),
    }
  end
end
