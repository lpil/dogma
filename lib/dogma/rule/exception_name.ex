defmodule Dogma.Rule.ExceptionName do
  @moduledoc """
  A Rule that checks that exception names end with a trailing Error.

  For example, prefer this:

      defmodule BadHTTPCodeError do
        defexception [:message]
      end

  Not one of these:

      defmodule BadHTTPCode do
        defexception [:message]
      end

      defmodule BadHTTPCodeException do
        defexception [:message]
      end
  """

  @behaviour Dogma.Rule
  @good_name_suffix "Error"

  alias Dogma.Script
  alias Dogma.Error

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node(
    {:defmodule, metadata, [{:__aliases__, _, name_arr}, children]} = node,
    errors
  ) do
    error_module? =
      children[:do]
      |> block_children_as_list
      |> Enum.any?(&exception?/1)
    name = Enum.join(name_arr, ".")

    if error_module? && bad_name?(name) do
      {node, [error(metadata[:line], name) | errors]}
    else
      {node, errors}
    end
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  defp bad_name?(name), do: !String.ends_with?(name, @good_name_suffix)

  def block_children_as_list({:__block__, _, children}), do: children
  def block_children_as_list(children), do: [children]

  defp exception?({:defexception, _, _}), do: true
  defp exception?(_), do: false

  defp error(line, _name) do
    %Error{
      rule:     __MODULE__,
      message:  "Exception names should end with '#{@good_name_suffix}'.",
      line: Dogma.Script.line(line),
    }
  end
end
