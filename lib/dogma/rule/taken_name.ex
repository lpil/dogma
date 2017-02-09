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

  reserved_words = ~w(
    __CALLER__ __DIR__ __ENV__ __MODULE__ abs alias apply bc binary_part
    binding bit_size byte_size case cond def defdelegate defexception defimpl
    defmacro defmacrop defmodule defoverridable defp defprotocol defstruct
    destructure div elem exit for function get_and_update_in get_in hd if
    import inbits inli inlist inspect is_atom is_binary is_bitstring is_boolean
    is_exception is_float is_function is_integer is_list is_map is_nil
    is_number is_pid is_port is_record is_reference is_tuple lc length make_ref
    map_size max min ast put_elem put_in quote raise receive rem require
    reraise respawn resque round self send sigil_C sigil_R sigil_S sigil_W
    sigil_c sigil_r sigil_s sigil_w spawn spawn_link spawn_monitor struct sum
    super throw tl to_char_list to_string trunc try tuple_size unless unquote
    unquote_splicing update_in use
  )a

  @reserved_words Enum.into(reserved_words, MapSet.new)

  @spec reserved_words :: MapSet.t
  def reserved_words do
    @reserved_words
  end

  def test(_rule, script) do
    script |> Script.walk( &check_ast(&1, &2) )
  end

  defp check_ast({:def, _, [{name, meta, _} | _]} = ast, errors) do
    check_name(name, meta, ast, errors)
  end
  defp check_ast({:defmacro, _, [{name, meta, _} | _]} = ast, errors) do
    check_name(name, meta, ast, errors)
  end
  defp check_ast({:defp, _, [{name, meta, _} | _]} = ast, errors) do
    check_name(name, meta, ast, errors)
  end
  defp check_ast(ast, errors) do
    {ast, errors}
  end

  defp valid_name?(name) do
    ! MapSet.member?(@reserved_words, name)
  end

  defp check_name(name, meta, ast, errors) when is_atom(name) do
    if valid_name?(name) do
      {ast, errors}
    else
      {ast, [error( meta[:line], name ) | errors]}
    end
  end

  defp check_name(_, _, ast, errors) do
    {ast, errors}
  end

  defp error(pos, name) do
    %Error{
      rule: __MODULE__,
      message: "`#{name}` is already taken and overrides standard library",
      line: pos,
    }
  end
end
