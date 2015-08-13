defmodule Dogma.Util.ScriptStrings do
  @moduledoc """
  A preprocessor for scripts, to be used on the script string before the AST,
  lines, etc have been computed for it.

  This is used to prevent the Rules for mistaking the contents of the strings
  for Elixir code and reporting errors when there should be none.
  """

  @doc """
  Takes a source string and return it with all of the string literals stripped
  of their contents.
  """
  def blank(script) do
    script |> not_in_string("")
  end


  def not_in_string("", acc) do
    acc
  end

  # \" is escaped, so continue
  def not_in_string(<< "\\\""::utf8, cs::binary >>, acc) do
    not_in_string(cs, acc <> "\\\"")
  end

  # If we meet a " we're inside a string, so switch
  def not_in_string(<< "\""::utf8, cs::binary >>, acc) do
    in_string(cs, acc <> "\"")
  end

  # Another other char we're still outside, so append to acc
  def not_in_string(<< c::utf8, cs::binary >>, acc) do
    not_in_string(cs, acc <> <<c>>)
  end


  def in_string("", acc) do
    acc
  end

  # \\ is not going to escape the next char, so continue
  def in_string(<< "\\\\"::utf8, cs::binary >>, acc) do
    in_string(cs, acc)
  end

  # \" is escaped, so continue
  def in_string(<< "\\\""::utf8, cs::binary >>, acc) do
    in_string(cs, acc)
  end

  # If we meet a " we're outside a string, so switch
  def in_string(<< "\""::utf8, cs::binary >>, acc) do
    not_in_string(cs, acc <> "\"")
  end

  # We want to preserve line numbers, so add newlines to acc
  def in_string(<< "\n"::utf8, cs::binary >>, acc) do
    in_string(cs, acc <> "\n")
  end

  # Another other char we're still inside, so don't add it to acc
  def in_string(<< _::utf8, cs::binary >>, acc) do
    in_string(cs, acc)
  end
end
