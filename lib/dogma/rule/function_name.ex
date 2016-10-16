use Dogma.RuleBuilder

defrule Dogma.Rule.FunctionName do
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

  alias Dogma.Util.Name

  def test(_rule, script) do
    script |> Script.walk( &check_ast(&1, &2) )
  end


  defp check_ast({:def, _, [{name, meta, _} | _]} = ast, errors) do
    check_function(name, meta, ast, errors)
  end
  defp check_ast({:defp, _, [{name, meta, _} | _]} = ast, errors) do
    check_function(name, meta, ast, errors)
  end
  defp check_ast(ast, errors) do
    {ast, errors}
  end

  # If the function is named by unquoting something then we can't check it
  defp check_function({:unquote, _, _} , _meta, ast, errors) do
    {ast, errors}
  end

  defp check_function(name, meta, ast, errors) do
    if name |> to_string |> Name.snake_case? do
      {ast, errors}
    else
      {ast, [error( meta[:line] ) | errors]}
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
