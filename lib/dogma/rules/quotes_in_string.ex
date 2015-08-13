defmodule Dogma.Rules.QuotesInString do
  @moduledoc """
  A rule that disallows strings containing double quotes.
  Use s_sigil or S_sigil instead.
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  sigals = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
            |> String.split("")
            |> Enum.map(fn(char) -> String.to_atom( "sigil_" <> char ) end)
  @sigils sigals

  # Don't check inside sigils
  for sigil <- @sigils do
    defp check_node({unquote(sigil), _, _}, errors) do
      {[], errors}
    end
  end

  # Don't check inside binary patterns
  defp check_node({:<<>>, _, _}, errors) do
    {[], errors}
  end

  defp check_node(bin, errors) when is_binary bin do
    if bin |> String.valid? do
      errors = check_string( bin, errors )
    end
    {node, errors}
  end

  defp check_node(node, errors) do
    {node, errors}
  end


  defp check_string(str, errors) do
    contains_quote       = fn(str) -> String.match?(str, ~r/"/) end
    probably_not_heredoc = fn(str) -> !String.ends_with?(str, "\n") end
    if contains_quote.(str) and probably_not_heredoc.(str) do
      # FIXME: How do we get the line number from a string?
      [error( nil ) | errors]
    else
      errors
    end
  end

  defp error(pos) do
    %Error{
      rule:     __MODULE__,
      message:  ~s(Prefer the S sigil for strings containing `"`),
      position: pos,
    }
  end
end
