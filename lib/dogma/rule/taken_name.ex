defmodule Dogma.Rule.TakenName do
  @moduledoc """
  A rule that disallows function or macro names which overrides standart lib.

  For example, this is considered valid:

    def just_do_it do
    end

    defmacro make_your_dreams_come_true(clause, expression) do
    end

  While this is considered invalid:

    def unless do
    end

    defmacro require(clause, expression) do
    end
  """

  @behaviour Dogma.Rule
  alias Dogma.Script
  alias Dogma.Error

  reserved_words = ~w(case if unless use unquote cond import respawn require
          def)
  @keywords  Enum.into(reserved_words, HashSet.new)

  def test(script, _config = [] \\ []) do
    script |> Script.walk( &check_node(&1, &2) )
  end

  defp check_node({:def, _, [{name, meta, _}|_]} = node, errors) do
    test_predicate(name, meta, node, errors)
  end
  defp check_node({:defmacro, _, [{name, meta, _}|_]} = node, errors) do
    test_predicate(name, meta, node, errors)
  end
  defp check_node({:defp, _, [{name, meta, _}|_]} = node, errors) do
    test_predicate(name, meta, node, errors)
  end
  defp check_node(node, errors) do
    {node, errors}
  end

  defp test_predicate(name) do
    if HashSet.member?(@keywords, name) do
      name
    else
      nil
    end
  end

  defp test_predicate({:unquote,_,_} , _meta, node, errors) do
    {node, errors}
  end

  defp test_predicate(function_name, meta, node, errors) do
    name = function_name |> to_string |> test_predicate
    if name do
      {node, [error( meta[:line], name ) | errors]}
    else
      {node, errors}
    end
  end

  defp error(pos, name) do
    %Error{
      rule:     __MODULE__,
      message:
          "`#{name}` is already taken and overrides standard library",
      line: Dogma.Script.line(pos),
    }
  end
end
