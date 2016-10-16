use Dogma.RuleBuilder

defrule Dogma.Rule.ExceptionName do
  @moduledoc """
  A Rule that checks that exception names end with a trailing Error.

  For example, prefer this:

      defmodule BadHTTPCodeError do
        defexception [:message]
      end

  Not one of these:

      defmodule BadHTTPCode do
        defexception [:message]
      end

      defmodule BadHTTPCodeException do
        defexception [:message]
      end
  """

  @good_name_suffix "Error"

  def test(_rule, script) do
    script |> Script.walk( &check_ast(&1, &2) )
  end

  defp check_ast(
    {:defmodule, metadata, [{:__aliases__, _, name_arr}, children]} = ast,
    errors
  ) do
    error_module? =
      children[:do]
      |> block_children_as_list
      |> Enum.any?(&exception?/1)
    name = Enum.join(name_arr, ".")

    if error_module? && bad_name?(name) do
      {ast, [error(metadata[:line], name) | errors]}
    else
      {ast, errors}
    end
  end
  defp check_ast(ast, errors) do
    {ast, errors}
  end

  defp bad_name?(name), do: !String.ends_with?(name, @good_name_suffix)

  def block_children_as_list({:__block__, _, children}), do: children
  def block_children_as_list(children), do: [children]

  defp exception?({:defexception, _, _}), do: true
  defp exception?(_), do: false

  defp error(line, _name) do
    %Error{
      rule:     __MODULE__,
      message:  "Exception names should end with '#{@good_name_suffix}'.",
      line: Dogma.Script.line(line),
    }
  end
end
