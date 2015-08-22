defmodule Dogma.Rules.ModuleDoc do
  @moduledoc """
  A rule that disallows the use of an if or unless with a negated predicate

  Skips .exs files.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  @file_to_be_skipped ~r/\.exs\z/

  def test(script) do
    if Regex.match?( @file_to_be_skipped, script.path ) do
      []
    else
      script |> Script.walk( &check_node(&1, &2) )
    end
  end

  defp check_node({:defmodule, m, [_, [do: module_body]]} = node, errors) do
    if module_body |> moduledoc? do
      {node, errors}
    else
      {node, [error( m[:line] ) | errors]}
    end
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  defp moduledoc?(node) do
    {_, pred} = Macro.prewalk( node, false, &moduledoc?(&1, &2) )
    pred
  end

  # moduledocs inside child modules don't count
  defp moduledoc?({:defmodule, _, _}, found_or_not) do
    {[], found_or_not}
  end

  # We've found a moduledoc
  defp moduledoc?({:@, _, [{:moduledoc, _, _} | _]}, _) do
    {[], true}
  end

  # We've already found one, so don't check further
  defp moduledoc?(_, true) do
    {[], true}
  end

  # Nothing here, keep looking
  defp moduledoc?(node, false) do
    {node, false}
  end

  defp error(position) do
    %Error{
      rule: __MODULE__,
      message: "Module without a @moduledoc detected.",
      position: position,
    }
  end
end
