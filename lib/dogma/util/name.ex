defmodule Dogma.Util.Name do
  @moduledoc """
  Utility functions for analysing names.
  """

  @doc """
  Returns true if the name is (probably) `snake_case`

      iex> Dogma.Util.Name.probably_snake_case?( "foo_bar" )
      true

      iex> Dogma.Util.Name.probably_snake_case?( "fooBar" )
      false
  """
  def probably_snake_case?(name) do
    not probably_not_snake_case?( name )
  end

  @doc """
  Returns true if the name is (probably) not `snake_case`

      iex> Dogma.Util.Name.probably_not_snake_case?( "foo_bar" )
      false

      iex> Dogma.Util.Name.probably_not_snake_case?( "fooBar" )
      true
  """
  def probably_not_snake_case?(name) do
    String.match?( name, ~r/[A-Z]/ )
  end


  @doc """
  Returns true if the name is (probably) `PascalCase`

      iex> Dogma.Util.Name.probably_pascal_case?( "FooBar" )
      true

      iex> Dogma.Util.Name.probably_pascal_case?( "fooBar" )
      false

      iex> Dogma.Util.Name.probably_pascal_case?( "foo_bar" )
      false
  """
  def probably_pascal_case?(name) do
    not probably_not_pascal_case?( name )
  end

  @doc """
  Returns true if the name is (probably) not `PascalCase`

      iex> Dogma.Util.Name.probably_not_pascal_case?( "FooBar" )
      false

      iex> Dogma.Util.Name.probably_not_pascal_case?( "fooBar" )
      true

      iex> Dogma.Util.Name.probably_not_pascal_case?( "foo_bar" )
      true
  """
  def probably_not_pascal_case?(name) do
    String.contains?( name, "_" ) or String.match?( name, ~r/\A[^A-Z]/ )
  end
end
