defmodule Dogma.Formatter.Simple do
  @moduledoc """
  A formatter that prints a dot per file, followed by details at the end.
  """

  @doc """
  Runs at the start of the test suite, displaying a file count
  """
  def start(files) do
    len = length( files )
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
      0 -> "."
      _ -> "X"
    end
  end

  @doc """
  Runs at the end of the test suite, displaying errors.
  """
  def finish(files) do
    {error_count, formatted_errors} = format_errors(files)
    """


    #{ length files } files, #{ error_count } errors.
    """ <> Enum.join( formatted_errors )
  end


  defp format_errors(scripts) do
    scripts
    |> Enum.reverse
    |> Enum.reduce({0, []}, fn(script, {count, errors}) ->
      new_errors = script |> format_script_errors
      count      = count + length( script.errors )
      {count, [new_errors | errors]}
    end)
  end

  defp format_script_errors(script) do
    case length script.errors do
      0 -> ""
      _ -> do_format_script_errors( script )
    end
  end
  defp do_format_script_errors(script) do
    errors = script.errors |> Enum.map( &format_error(&1) )
    """

    == #{ script.path } ==#{ errors }
    """
  end

  defp format_error(error) do
    "\n#{error.position}: #{shorten error.rule}: #{error.message}"
  end

  defp shorten(rule) do
   rule |> to_string |> String.split(".") |> List.last
  end
end
