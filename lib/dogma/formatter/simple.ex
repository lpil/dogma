defmodule Dogma.Formatter.Simple do
  @moduledoc """
  A formatter that prints a dot per file, followed by details at the end.

      Inspecting 27 files.

      .....X..........X..........

      27 files, 2 errors!

      == lib/dogma/rules.ex ==
      23: TrailingBlankLines: Blank lines detected at end of file

      == test/dogma/formatter_test.exs ==
      9: TrailingWhitespace: Trailing whitespace detected [33]
  """

  @behaviour Dogma.Formatter

  @doc """
  Runs at the start of the test suite, displaying a file count
  """
  def start(scripts) do
    len = length( scripts )
    case len do
      0 -> "No tests to run!"
      1 -> "Inspecting #{len} file."
      _ -> "Inspecting #{len} files."
    end <> "\n\n"
  end

  @doc """
  Runs after each script is tested. Prints a dot!
  """
  def script(script) do
    case length( script.errors ) do
      0 -> IO.ANSI.green <> "."
      _ -> IO.ANSI.red   <> "X"
    end <> IO.ANSI.reset
  end

  @doc """
  Runs at the end of the test suite, displaying errors.
  """
  def finish(scripts, fix? \\ false)
  def finish(scripts, false) do
    {error_count, errors} = format_errors( scripts )
    len = length(scripts)
    "\n\n" <> summary( len, error_count ) <> Enum.join( errors ) <> "\n"
  end
  def finish(scripts, true) do
    {err_count, fix_count, unfixed} = format_errors_and_fixes( scripts )
    summary = summary_with_fixes(length(scripts), err_count, fix_count)
    "\n\n" <> summary <> Enum.join( unfixed ) <> "\n"
  end

  defp reset do
    IO.ANSI.reset <> "\n"
  end

  defp summary(num, 0) do
    "#{ num } files, #{ IO.ANSI.green }no errors!" <> reset
  end
  defp summary(num, 1) do
    "#{ num } files, #{ IO.ANSI.red }1 error!" <> reset
  end
  defp summary(num, err_count) do
    "#{ num } files, #{ IO.ANSI.red }#{ err_count } errors!" <> reset
  end

  defp summary_with_fixes(file_count, error_count, fix_count) do
    conclusion = format_conclusion(error_count - fix_count)
    error_count_formatted =
      case error_count do
        1 -> "1 error"
        _ -> "#{error_count} errors"
      end

    "#{file_count} files, #{error_count_formatted},"
      <> " #{fix_count} fixed, #{conclusion}" <> reset
  end

  defp format_conclusion(remaining) do
    case remaining do
      0 -> "#{IO.ANSI.green}no errors remaining!"
      1 -> "#{IO.ANSI.red}1 error remaining!"
      _ -> "#{IO.ANSI.red}#{remaining} errors remaining!"
    end
  end


  defp format_errors(scripts) do
    scripts
    |> Enum.reverse
    |> Enum.reduce({0, []}, fn(script, {count, errors}) ->
      new_errors = script.errors |> format_script_errors(script.path)
      count      = count + length( script.errors )
      {count, [new_errors | errors]}
    end)
  end

  defp format_errors_and_fixes(scripts) do
    scripts
    |> Enum.reverse
    |> Enum.reduce({0, 0, []}, fn(script, {count, fix_count, errors}) ->
      count = count + length( script.errors )
      {fixed, unfixed} = Enum.partition(script.errors, fn err -> err.fixed? end)
      fix_count = fix_count + length(fixed)
      new_errors = unfixed |> format_script_errors(script.path)

      {count, fix_count, [new_errors | errors]}
    end)
  end

  defp format_script_errors(errors, path) do
    case length errors do
      0 -> ""
      _ -> do_format_script_errors( errors, path )
    end
  end
  defp do_format_script_errors(errors, path) do
    errors = errors |> Enum.map( &format_error(&1) )
    """

    == #{ path } ==#{ errors }
    """
  end

  defp format_error(error) do
    "\n#{error.line}: #{shorten error.rule}: #{error.message}"
  end

  defp shorten(rule) do
   rule |> to_string |> String.split(".") |> List.last
  end
end
