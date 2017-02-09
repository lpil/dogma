defmodule Dogma.Script.Metadata do
  @moduledoc """
  Responsible for extracting comments and contained metadata from a source
  string.
  """

  alias Dogma.Script
  alias Dogma.Util.Comment

  def add(script) do
    comments = script.processed_lines |> Comment.get_all
    index    = comments |> build_ignore_index
    %Script{ script | comments: comments, ignore_index: index }
  end


  defp dogma_ignore_comment?(%Comment{content: content}) do
    content
    |> String.downcase
    |> String.starts_with?(" dogma:ignore")
  end

  defp build_ignore_index(comments) do
    comments
    |> Enum.filter(&dogma_ignore_comment?/1)
    |> Enum.reduce(%{}, &add_comment_to_index/2)
  end

  defp add_comment_to_index(%Comment{content: content, line: n}, index) do
    content
    |> String.split
    |> tl
    |> Enum.reduce(index, fn rule, acc -> add_rule_to_index(acc, rule, n) end)
  end

  defp add_rule_to_index(index, rule, n) do
    rule = "Elixir.#{rule}" |> String.to_atom
    set  = index |> Map.get( rule, MapSet.new ) |> MapSet.put( n )
    Map.put( index, rule, set )
  end
end
