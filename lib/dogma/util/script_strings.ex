defmodule Dogma.Util.ScriptStrings do
  @moduledoc """
  A preprocessor for scripts, to be used on the script string before the AST,
  lines, etc have been computed for it.

  This is used to prevent the Rules for mistaking the contents of the strings
  for Elixir code and reporting errors when there should be none.
  """

  @quote   34 # The int for a "  is 34
  @newline 10 # The int for a \n is 10

  @doc """
  Takes a source string and return it with all of the string literals stripped
  of their contents.
  """
  def blank(script) do
    script
    |> String.to_char_list
    |> not_in_string([])
    |> Enum.reverse
    |> List.to_string
  end


  defp not_in_string('', acc) do
    acc
  end

  # If we meet a " we're inside a string, so switch
  defp not_in_string([@quote|xs], acc) do
    in_string(xs, [@quote|acc])
  end

  # Another other char we're still outside, so prepend to acc
  defp not_in_string([x|xs], acc) do
    not_in_string(xs, [x|acc])
  end



  defp in_string('', acc) do
    acc
  end

  # If we meet a " we're outside a string, so switch
  defp in_string([@quote|xs], acc) do
    not_in_string(xs, [@quote|acc])
  end

  # We want to preserve line numbers, so add newlines to acc
  defp in_string([@newline|xs], acc) do
    in_string(xs, [@newline|acc])
  end

  # Another other char we're still inside, so don't add it to acc
  defp in_string([_|xs], acc) do
    in_string(xs, acc)
  end
end
