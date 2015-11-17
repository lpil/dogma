defmodule Dogma.Util.ScriptSigils do
  @moduledoc """
  A preprocessor for scripts, to be used on the script string before the AST,
  lines, etc have been computed for it.

  This is used to prevent the Rules for mistaking the contents of the sigils
  for Elixir code and reporting errors when there should be none.
  """

  sigil_chars =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.graphemes

  sigil_delimiters = [
    "||", ~S(""), "''", "()", "[]", "{}", "<>", "//",
  ] |> Enum.map(&String.graphemes/1)

  sigils = for(
    [open, close] <- sigil_delimiters,
    char <- sigil_chars
  ) do
    {"~#{char}#{open}", close}
  end

  @doc """
  Takes a source string and return it with all of the sigil literals stripped
  of their contents.
  """
  def strip(script) do
    script |> parse_code("")
  end

  defp parse_code("", acc) do
    acc
  end
  for {open, close} <- sigils do
    defp parse_code(<< unquote(open)::utf8, t::binary >>, acc) do
      parse_sigil(t, acc <> unquote(open), unquote(close))
    end
  end
  defp parse_code(<< h::utf8, t::binary >>, acc) do
    parse_code(t, acc <> <<h>>)
  end

  for {_open, close} <- sigils do
    defp parse_sigil("", acc, unquote(close)) do
      acc
    end
    defp parse_sigil(<< "\\\\"::utf8, t::binary >>, acc, unquote(close)) do
      parse_sigil(t, acc, unquote(close))
    end
    defp parse_sigil(
      << "\\"::utf8, unquote(close)::utf8, t::binary >>, acc, unquote(close)
    ) do
      parse_sigil(t, acc, unquote(close))
    end
    defp parse_sigil(<< "\n"::utf8, t::binary >>, acc, unquote(close)) do
      parse_sigil(t, acc <> "\n", unquote(close))
    end
    defp parse_sigil(
      << unquote(close)::utf8, t::binary >>, acc, unquote(close)
    ) do
      parse_code(t, acc <> unquote(close))
    end
    defp parse_sigil(<< _::utf8, t::binary >>, acc, unquote(close)) do
      parse_sigil(t, acc, unquote(close))
    end
  end
end
