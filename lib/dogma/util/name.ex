defmodule Dogma.Util.Name do
  @moduledoc """
  Utility functions for analysing names.
  """

  @doc """
  Returns true if the name is in `snake_case`.

      iex> Dogma.Util.Name.snake_case?("to_string")
      true

      iex> Dogma.Util.Name.snake_case?("starts_with?")
      true

      iex> Dogma.Util.Name.snake_case?("read!")
      true

      iex> Dogma.Util.Name.snake_case?("foo_bar_baz")
      true

      iex> Dogma.Util.Name.snake_case?("fooBar")
      false

      iex> Dogma.Util.Name.snake_case?("Foobar")
      false

      iex> Dogma.Util.Name.snake_case?("foo_Bar")
      false
  """
  def snake_case?(name) do
    name |> String.match?(~r/^[a-z0-9\_\?\!]+$/)
  end

  @doc """
  Returns true if the name is not in `snake_case`

      iex> Dogma.Util.Name.not_snake_case?( "foo_bar" )
      false

      iex> Dogma.Util.Name.not_snake_case?( "fooBar" )
      true
  """
  def not_snake_case?(name) do
    not snake_case?(name)
  end


  @doc """
  Returns true if the name is in `PascalCase`

      iex> Dogma.Util.Name.pascal_case?( "GenServer" )
      true

      iex> Dogma.Util.Name.pascal_case?( "IO" )
      true

      iex> Dogma.Util.Name.pascal_case?( "fooBar" )
      false

      iex> Dogma.Util.Name.pascal_case?( "foo_bar" )
      false
  """
  def pascal_case?(name) do
    name |> String.match?(~r/^[A-Z][a-zA-Z0-9]*$/)
  end

  @doc """
  Returns true if the name is not in `PascalCase`

      iex> Dogma.Util.Name.not_pascal_case?( "GenServer" )
      false

      iex> Dogma.Util.Name.not_pascal_case?( "fooBar" )
      true

      iex> Dogma.Util.Name.not_pascal_case?( "foo_bar" )
      true
  """
  def not_pascal_case?(name) do
    not pascal_case?(name)
  end
end
