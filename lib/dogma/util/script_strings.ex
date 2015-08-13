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


  defp not_in_string("", acc) do
    acc
  end

  # \" is escaped, so continue
  defp not_in_string(<< "\\\""::utf8, cs::binary >>, acc) do
    not_in_string(cs, acc <> ~S(\"))
  end

  # If we meet a """ we're inside a docstring, so switch
  defp not_in_string(<< "\"\"\""::utf8, cs::binary >>, acc) do
    in_docstring(cs, acc <> ~s("""))
  end

  # If we meet a " we're inside a string, so switch
  defp not_in_string(<< "\""::utf8, cs::binary >>, acc) do
    in_string(cs, acc <> ~s("))
  end

  # Any other char we're still outside, so append to acc
  defp not_in_string(<< c::utf8, cs::binary >>, acc) do
    not_in_string(cs, acc <> <<c>>)
  end



  defp in_docstring("", acc) do
    acc
  end

  # We want to preserve line numbers, so add newlines to acc
  defp in_docstring(<< "\n"::utf8, cs::binary >>, acc) do
    in_docstring(cs, acc <> "\n")
  end

  # \\ is not going to escape the next char, so continue
  defp in_docstring(<< "\\\\"::utf8, cs::binary >>, acc) do
    in_docstring(cs, acc)
  end

  # \" is escaped, so continue
  defp in_docstring(<< "\\\""::utf8, cs::binary >>, acc) do
    in_docstring(cs, acc)
  end

  # If we meet """ we're outside a string, so switch
  defp in_docstring(<< "\"\"\""::utf8, cs::binary >>, acc) do
    not_in_string(cs, acc <> ~s("""))
  end

  # Any other char we're still inside, so don't add it to acc
  defp in_docstring(<< _::utf8, cs::binary >>, acc) do
    in_docstring(cs, acc)
  end



  defp in_string("", acc) do
    acc
  end

  # \\ is not going to escape the next char, so continue
  defp in_string(<< "\\\\"::utf8, cs::binary >>, acc) do
    in_string(cs, acc)
  end

  # \" is escaped, so continue
  defp in_string(<< "\\\""::utf8, cs::binary >>, acc) do
    in_string(cs, acc)
  end

  # If we meet a " we're outside a string, so switch
  defp in_string(<< "\""::utf8, cs::binary >>, acc) do
    not_in_string(cs, acc <> ~s("))
  end

  # We want to preserve line numbers, so add newlines to acc
  defp in_string(<< "\n"::utf8, cs::binary >>, acc) do
    in_string(cs, acc <> "\n")
  end

  # Any other char we're still inside, so don't add it to acc
  defp in_string(<< _::utf8, cs::binary >>, acc) do
    in_string(cs, acc)
  end
end
