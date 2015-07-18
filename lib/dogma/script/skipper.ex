defmodule Dogma.Script.Skipper do
  @moduledoc """
  Uses general config to determine if a file should be skipped.
  """

  @exs_file ~r/\.exs\z/

  def skip?(script, skip_exs_files: true) do
    Regex.match?( @exs_file, script.path )
  end

  def skip?(script, _) do
    false
  end

end
