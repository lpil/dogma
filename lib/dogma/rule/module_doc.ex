defmodule Dogma.Rule.ModuleDoc do
  @moduledoc """
  A rule which states that all modules must have documentation in the form of a
  `@moduledoc` attribute.

  This rule does run check interpreted Elixir files, i.e. those with the file
  extension `.exs`.

  This would be valid according to this rule:

      defmodule MyModule do
        @moduledoc \"\"\"
        This module is valid as it has a moduledoc!
        Ideally the documentation would be more useful though...
        \"\"\"
      end

  This would not be valid:

      defmodule MyModule do
      end

  If you do not want to document a module, explicitly do so by setting the
  attribute to `false`.

      defmodule MyModule do
        @moduledoc false
      end
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  @file_to_be_skipped ~r/\.exs\z/

  def test(script, _config = [] \\ []) do
    if Regex.match?( @file_to_be_skipped, script.path ) do
      []
    else
      script |> Script.walk( &check_node(&1, &2) )
    end
  end

  defp check_node({:defmodule, m, [mod, [do: module_body]]} = node, errors) do
    {_,_,names} = mod
    if module_body |> moduledoc? do
      {node, errors}
    else
      {node, [error( m[:line], Enum.join(names, ".") ) | errors]}
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

  defp error(position, module_name) do
    %Error{
      rule:    __MODULE__,
      message: "Module #{module_name} is missing a @moduledoc.",
      line:    position,
    }
  end
end
