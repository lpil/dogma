defmodule Dogma.Util.CyclomaticComplexity do
  @moduledoc """
  A module for calculating the cyclomatic complexity for an AST.
  """

  @branching_nodes ~w(if unless case cond && and || or)a

  @doc """
  Returns the cyclomatic complexity of a given AST.
  """
  def count(ast) do
    {_, size} = Macro.prewalk( ast, 1, &count( &1, &2 ) )
    size
  end

  for name <- @branching_nodes do
    def count({unquote(name), _, _} = ast, size) do
      {ast, size + 1}
    end
  end

  def count(ast, acc) do
    {ast, acc}
  end
end
