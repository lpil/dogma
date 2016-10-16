defmodule Dogma.Util.AST do
  @moduledoc """
  Utility functions for analyzing and categorizing AST asts
  """

  sigil_chars =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.graphemes

  @doc """
  Returns true if the ast x is a literal

  ## Examples:

      iex> Dogma.Util.AST.literal?( "foo" )
      true

      iex> Dogma.Util.AST.literal?({:foo, [], Elixir})
      false
  """
  def literal?(x) when is_atom(x), do: true
  def literal?(x) when is_binary(x), do: true
  def literal?(x) when is_boolean(x), do: true
  def literal?(x) when is_number(x), do: true
  def literal?(x) when is_list(x), do: Enum.all?(x, &literal?/1)
  def literal?({x, y}), do: literal?(x) && literal?(y)
  def literal?({:{}, _, elements}), do: literal?(elements)
  def literal?({:%{}, _, _}), do: true

  for char <- sigil_chars do
    sigil_atom = String.to_atom("sigil_" <> char)
    def literal?({unquote(sigil_atom), _, _}), do: true
  end
  def literal?(_), do: false
end
