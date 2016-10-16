use Dogma.RuleBuilder

defrule Dogma.Rule.PredicateName do
  @moduledoc """
  A rule that disallows tautological predicate names, meaning those that start
  with the prefix `has_` or the prefix `is_`.

  Favour these:

      def valid?(x) do
      end

      def picture?(x) do
      end

  Over these:

      def is_valid?(x) do
      end

      def has_picture?(x) do
      end
  """

  def test(_rule, script) do
    script |> Script.walk( &check_ast(&1, &2) )
  end

  defp check_ast({:def, _, [{name, meta, _} | _]} = ast, errors) do
    test_predicate(name, meta, ast, errors)
  end
  defp check_ast({:defp, _, [{name, meta, _} | _]} = ast, errors) do
    test_predicate(name, meta, ast, errors)
  end
  defp check_ast(ast, errors) do
    {ast, errors}
  end

  defp test_predicate(line) do
    Regex.run(~r{\A(is|has)_(\w+)\?\Z}, line)
  end

  defp test_predicate({:unquote, _, _} , _meta, ast, errors) do
    {ast, errors}
  end

  defp test_predicate(function_name, meta, ast, errors) do
    name = function_name |> to_string |> test_predicate
    if name do
      {ast, [error( meta[:line], name ) | errors]}
    else
      {ast, errors}
    end
  end

  defp error(pos, [name, _prefix, suffix]) do
    %Error{
      rule:     __MODULE__,
      message:  "Favour `#{suffix}?` over `#{name}`",
      line: Dogma.Script.line(pos),
    }
  end
end
