defmodule Dogma.Util.ASTNode do
  @moduledoc"""
  Utility functions for analyzing and categorizing AST nodes
  """

  @doc """
  Returns true if the node x is a literal
      
      iex> Dogma.Util.ASTNode.literal?( "foo" )
      true

      iex> Dogma.Util.ASTNode.literal?({:foo, [], Elixir})
      false
  """
  def literal?(x) when is_atom    x do true end
  def literal?(x) when is_binary  x do true end
  def literal?(x) when is_boolean x do true end
  def literal?(x) when is_list    x do true end
  def literal?(x) when is_number  x do true end
  def literal?({_,_})               do true end
  def literal?({:{}, _, _})         do true end
  def literal?({:%{}, _, _})        do true end
  def literal?(node) do
    sigil?(node)
  end

  def sigil?({fun, _, _}) when is_atom fun do
    fun |> to_string |> String.starts_with?("sigil_")
  end
  def sigil?(_) do false end
end
