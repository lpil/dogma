use Dogma.RuleBuilder

defrule Dogma.Rule.CommentFormat, [allow_multiple_hashes: true] do
  @moduledoc """
  A rule that disallows comments with no space between the # and the comment
  text.

  This is considered valid:

      # Here is a function:
      #
      #   def inc(n), do: n + 1

  This is considered invalid:

      #Hello, world!
  """

  def test(rule, script) do
    script.comments
    |> Enum.reduce([], fn comment, errors ->
      if check_comment(comment, rule.allow_multiple_hashes) do
        [error(comment.line) | errors]
      else
        errors
      end
    end)
  end

  defp check_comment(comment, allow_multiple_hashes) do
    case comment.content do
      "" -> false

      << "#"::utf8, rest::binary >> ->
        hashes_error?(rest, allow_multiple_hashes)

      # Allow the 'shebang' line, common in *nix scripts.
      << "!"::utf8, _::binary >> -> comment.line != 1

      << " "::utf8, _::binary >> -> false

      _ -> true
    end
  end

  defp hashes_error?(content, allow_multiple_hashes)
  defp hashes_error?("", _), do: false
  defp hashes_error?(<< " "::utf8, _::binary >>, true), do: false
  defp hashes_error?(<< "#"::utf8, rest::binary >>, true) do
    hashes_error?(rest, true)
  end
  defp hashes_error?(_, _), do: true

  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Comments should start with a single space",
      line:    pos
    }
  end
end
