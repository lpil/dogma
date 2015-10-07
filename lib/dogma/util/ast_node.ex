defmodule Dogma.Util.AST do
  @moduledoc """
  Utility functions for analyzing and categorizing AST nodes
  """

  @sigil_chars "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

  @doc """
  Returns true if the node x is a literal

  ## Examples:

      iex> Dogma.Util.AST.literal?( "foo" )
      true

      iex> Dogma.Util.AST.literal?({:foo, [], Elixir})
      false
  """
  def literal?(x) when is_atom(x), do: true
  def literal?(x) when is_binary(x), do: true
  def literal?(x) when is_boolean(x), do: true
  def literal?(x) when is_list(x), do: true
  def literal?(x) when is_number(x), do: true
  def literal?({_,_}), do: true
  def literal?({:{}, _, _}), do: true
  def literal?({:%{}, _, _}), do: true

  for char <- String.split(@sigil_chars, "", trim: true) do
    sigil_atom = String.to_atom("sigil_" <> char)
    def literal?({unquote(sigil_atom),_,_}), do: true
  end
  def literal?(_), do: false
end
