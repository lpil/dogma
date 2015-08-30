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
  def literal?(x) when is_atom       x do true end
  def literal?(x) when is_binary     x do true end
  def literal?(x) when is_bitstring  x do true end
  def literal?(x) when is_boolean    x do true end
  def literal?(x) when is_function   x do true end
  def literal?(x) when is_list       x do true end
  def literal?(x) when is_map        x do true end
  def literal?(x) when is_pid        x do true end
  def literal?(x) when is_port       x do true end
  def literal?(x) when is_number     x do true end
  def literal?(x) when is_reference  x do true end
  def literal?({:{}, _, _}) do
    true
  end
  def literal?(_) do
    false
  end
end
