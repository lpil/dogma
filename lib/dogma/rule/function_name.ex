defmodule Dogma.Rule.FunctionName do
  @moduledoc """
  A rule that disallows function names not in `snake_case`.

  `snake_case` is when only lowercase letters are used, and words are separated
  with underscores, rather than spaces.

  For example, this rule considers these function definition valid:

      def my_mood do
        :happy
      end

      defp my_belly do
        :full
      end

  But it considers these invalid:

      def myMood do
        :sad
      end

      defp myBelly do
        :empty
      end
  """

  @behaviour Dogma.Rule

  alias Dogma.Script
  alias Dogma.Error
  alias Dogma.Util.Name

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end


  defp check_node({:def, _, [{name, meta, _}|_]} = node, errors) do
    check_function(name, meta, node, errors)
  end
  defp check_node({:defp, _, [{name, meta, _}|_]} = node, errors) do
    check_function(name, meta, node, errors)
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  # If the function is named by unquoting something then we can't check it
  defp check_function({:unquote,_,_} , _meta, node, errors) do
    {node, errors}
  end

  defp check_function(name, meta, node, errors) do
    if name |> to_string |> Name.snake_case? do
      {node, errors}
    else
      {node, [error( meta[:line] ) | errors]}
    end
  end

  defp error(pos) do
    %Error{
      rule:    __MODULE__,
      message: "Function names should be in snake_case",
      line:    pos,
    }
  end
end
