defmodule Dogma.Rule.ModuleName do
  @moduledoc """
  A rule that disallows module names not in PascalCase.

  For example, this is considered valid:

      defmodule HelloWorld do
      end

  While this is considered invalid:

      defmodule Hello_World do
      end
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error
  alias Dogma.Util.Name

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:defmodule, m, [x, _]} = node, errors) when is_atom x do
    errors = check_names( [x], errors, m[:line] )
    {node, errors}
  end
  defp check_node({:defmodule, m, [{:__aliases__, _, x}, _]} = node, errors) do
    errors = check_names( x, errors, m[:line] )
    {node, errors}
  end
  defp check_node(node, errors) do
    {node, errors}
  end


  defp check_names(names, errors, line) do
    names
    |> Enum.flat_map( &prepare_names(&1) )
    |> Enum.filter( &Name.not_pascal_case?(&1) )
    |> case do
       [] ->
         errors
       _  ->
         [error( line ) | errors]
    end
  end


  defp prepare_names(names) do
    names |> Atom.to_string |> String.split(".")
  end


  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Module names should be in PascalCase",
      line: Dogma.Script.line(pos),
    }
  end
end
