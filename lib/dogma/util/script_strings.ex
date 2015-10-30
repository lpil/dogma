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
  def strip(script) do
    script |> parse_code("")
  end

  defp parse_code("", acc) do
    acc
  end
  defp parse_code(<< "\\\""::utf8, t::binary >>, acc) do
    parse_code(t, acc <> ~s(\\"))
  end
  defp parse_code(<< "?\""::utf8, t::binary >>, acc) do
    parse_code(t, acc <> ~S(?"))
  end
  defp parse_code(<< "\"\"\""::utf8, t::binary >>, acc) do
    parse_heredoc(t, acc <> ~s("""))
  end
  defp parse_code(<< "\""::utf8, t::binary >>, acc) do
    parse_string_literal(t, acc <> ~S("))
  end
  defp parse_code(<< h::utf8, t::binary >>, acc) do
    parse_code(t, acc <> <<h>>)
  end

  defp parse_string_literal("", acc) do
    acc
  end
  defp parse_string_literal(<< "\\\\"::utf8, t::binary >>, acc) do
    parse_string_literal(t, acc)
  end
  defp parse_string_literal(<< "\\\""::utf8, t::binary >>, acc) do
    parse_string_literal(t, acc)
  end
  defp parse_string_literal(<< "\""::utf8, t::binary >>, acc) do
    parse_code(t, acc <> ~s("))
  end
  defp parse_string_literal(<< "\n"::utf8, t::binary >>, acc) do
    parse_string_literal(t, acc <> "\n")
  end
  defp parse_string_literal(<< _::utf8, t::binary >>, acc) do
    parse_string_literal(t, acc)
  end

  defp parse_heredoc("", acc) do
    acc
  end
  defp parse_heredoc(<< "\\\\"::utf8, t::binary >>, acc) do
    parse_heredoc(t, acc)
  end
  defp parse_heredoc(<< "\\\""::utf8, t::binary >>, acc) do
    parse_heredoc(t, acc)
  end
  defp parse_heredoc(<< "\"\"\""::utf8, t::binary >>, acc) do
    parse_code(t, acc <> ~s("""))
  end
  defp parse_heredoc(<< "\n"::utf8, t::binary >>, acc) do
    parse_heredoc(t, acc <> "\n")
  end
  defp parse_heredoc(<< _::utf8, t::binary >>, acc) do
    parse_heredoc(t, acc)
  end
end
