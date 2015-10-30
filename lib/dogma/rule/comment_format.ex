defmodule Dogma.Rule.CommentFormat do
  @moduledoc """
  """

  @behaviour Dogma.Rule

  alias Dogma.Error

  def test(script, _config = [] \\ []) do
    script.comments |> Enum.reduce([], &check_comment/2)
  end


  defp check_comment(comment, errors) do
    case comment.content do
      "" ->
        errors

      << " "::utf8, _::binary >> ->
        errors

      _ ->
        [error( comment.line ) | errors]
    end
  end

  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Comments should start with a single space",
      line:    pos
    }
  end
end
