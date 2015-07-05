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
  Returns true if the name is (probably) `CamelCase`

      iex> Dogma.Util.Name.probably_camel_case?( "FooBar" )
      true

      iex> Dogma.Util.Name.probably_camel_case?( "fooBar" )
      false

      iex> Dogma.Util.Name.probably_camel_case?( "foo_bar" )
      false
  """
  def probably_camel_case?(name) do
    not probably_not_camel_case?( name )
  end

  @doc """
  Returns true if the name is (probably) not `CamelCase`

      iex> Dogma.Util.Name.probably_not_camel_case?( "FooBar" )
      false

      iex> Dogma.Util.Name.probably_not_camel_case?( "fooBar" )
      true

      iex> Dogma.Util.Name.probably_not_camel_case?( "foo_bar" )
      true
  """
  def probably_not_camel_case?(name) do
    String.contains?( name, "_" ) or String.match?( name, ~r/\A[^A-Z]/ )
  end
end
