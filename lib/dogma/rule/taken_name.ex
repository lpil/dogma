use Dogma.RuleBuilder

defrule Dogma.Rule.TakenName do
  @moduledoc """
  A rule that disallows function or macro names which overrides standard lib.

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

  other_reserved_words = ~w(
    __CALLER__ __DIR__ __ENV__ __MODULE__ abs alias apply bc binary_part
    binding bit_size byte_size case cond def defdelegate defexception defimpl
    defmacro defmacrop defmodule defoverridable defp defprotocol defstruct
    destructure div elem exit for function get_and_update_in get_in hd if
    import inbits inli inlist is_atom is_binary is_bitstring is_boolean
    is_exception is_float is_function is_integer is_list is_map is_nil
    is_number is_pid is_port is_record is_reference is_tuple lc length make_ref
    map_size max min ast put_elem put_in quote raise receive rem require
    reraise respawn resque round self send sigil_C sigil_R sigil_S sigil_W
    sigil_c sigil_r sigil_s sigil_w spawn spawn_link spawn_monitor struct sum
    super throw tl to_char_list trunc try tuple_size unless unquote
    unquote_splicing update_in use
  )a

  @other_reserved_words Enum.into(other_reserved_words, MapSet.new)

  @protocol_with_reserved_words %{
    [:Inspect] => :inspect,
    [:List, :Chars] => :to_charlist,
    [:String, :Chars] => :to_string
  }

  @reserved_words @protocol_with_reserved_words
    |> Map.values()
    |> Enum.into(@other_reserved_words)

  @spec reserved_words :: MapSet.t
  def reserved_words do
    @reserved_words
  end

  @spec protocol_with_reserved_words :: %{required([atom]) => atom}
  def protocol_with_reserved_words do
    @protocol_with_reserved_words
  end

  def test(_rule, script) do
    {_, {_, errors}} =
      Macro.traverse( script.ast, {@reserved_words, []},
        &check_ast(&1, &2),
        &end_of_impl(&1, &2))
    errors
  end

  defp check_ast({:def, _, [{name, meta, _} | _]} = ast, acc) do
    check_name(name, meta, ast, acc)
  end
  defp check_ast({:defmacro, _, [{name, meta, _} | _]} = ast, acc) do
    check_name(name, meta, ast, acc)
  end
  defp check_ast({:defp, _, [{name, meta, _} | _]} = ast, acc) do
    check_name(name, meta, ast, acc)
  end
  defp check_ast(
    {:defimpl, _, [{_, _, impl_name} | _]} = ast,
    {reserved, errors}) do
    new_reserved = update_reserved_words(reserved, impl_name, &MapSet.delete/2)
    {ast, {new_reserved, errors}}
  end
  defp check_ast(ast, acc) do
    {ast, acc}
  end

  defp end_of_impl(
    {:defimpl, _, [{_, _, impl_name} | _]} = ast,
    {reserved, errors}) do
    new_reserved = update_reserved_words(reserved, impl_name, &MapSet.delete/2)
    {ast, {new_reserved, errors}}
  end
  defp end_of_impl(ast, acc) do
    {ast, acc}
  end

  defp valid_name?(name, reserved) do
    ! MapSet.member?(reserved, name)
  end

  defp check_name(name, meta, ast, {reserved, errors}) when is_atom(name) do
    if valid_name?(name, reserved) do
      {ast, {reserved, errors}}
    else
      {ast, {reserved, [error( meta[:line], name ) | errors]}}
    end
  end

  defp check_name(_, _, ast, acc) do
    {ast, acc}
  end

  defp update_reserved_words(words, implementation_name, update_function) do
    case Map.fetch protocol_with_reserved_words(), implementation_name do
      {:ok, changeing_name} -> update_function.(words, changeing_name)
      :error -> words
    end
  end

  defp error(pos, name) do
    %Error{
      rule: __MODULE__,
      message: "`#{name}` is already taken and overrides standard library",
      line: pos,
    }
  end
end
