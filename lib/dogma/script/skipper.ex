defmodule Dogma.Script.Skipper do
  @moduledoc """
  Uses general config to determine if a file should be skipped.
  """

  @exs_file ~r/\.exs\z/

  def skip?(script, options \\ []) do
    skip_exs? = options |> Keyword.get(:skip_exs_files, false)
    skip_exs? && Regex.match?( @exs_file, script.path )
  end

end
