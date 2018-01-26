defmodule Dogma.Runner do
  @moduledoc """
  Run each of the given on the given script
  """

  alias Dogma.Rule
  alias Dogma.Script

  def run_tests(%Script{ valid?: false, errors: errors }, _rules) do
    errors
  end

  def run_tests(%Script{} = script, rules) when is_list(rules) do
    rules
    |> Enum.filter(&(&1.enabled))
    |> Enum.map(fn rule ->
         filtered_script = filter_script(script, rule)

         Rule.test(rule, filtered_script)
       end)
    |> List.flatten
  end

  defp filter_script(script, rule) do
    rule_name = rule_name(rule)

    %Dogma.Script{script |
      lines: filter_lines(script, rule_name),
      processed_lines: filter_processed_lines(script, rule_name),
      tokens: filter_tokens(script, rule_name)
    }
  end

  defp filter_lines(script, rule_name) do
    script.lines
    |> Enum.with_index
    |> Enum.filter(&(!line_ignored(&1, script.ignore_index, rule_name)))
    |> Enum.map(fn {line, _index} -> line end)
  end

  defp filter_processed_lines(script, rule_name) do
    script.processed_lines
    |> Enum.with_index
    |> Enum.filter(&(!line_ignored(&1, script.ignore_index, rule_name)))
    |> Enum.map(fn {line, _index} -> line end)
  end

  defp filter_tokens(script, rule_name) do
    script.tokens
    |> Enum.filter(fn token ->
      case token do
        {_, {line_number, _, _},_} ->
          !line_ignored(line_number, script.ignore_index, rule_name)
        {_, {line_number, _, _}} ->
          !line_ignored(line_number, script.ignore_index, rule_name)
        _ ->
          true
      end
    end)
  end

  defp line_ignored(line_number, ignore_index, rule_name)
    when is_number(line_number)
  do
    ignore_index
    |> Map.get(rule_name, MapSet.new())
    |> MapSet.member?(line_number)
  end
  defp line_ignored({_, index}, ignore_index, rule_name) do
    line_number = index + 1

    line_ignored(line_number, ignore_index, rule_name)
  end

  defp rule_name(rule) do
    rule.__struct__
    |> Atom.to_string
    |> String.split(".")
    |> List.last
    |> String.replace_prefix("", "Elixir.")
    |> String.to_atom
  end
end
