defmodule Dogma.RulesRunBench do
  use Benchfella

  alias Dogma.Rules
  alias Dogma.ScriptSources

  @sample_script_path ""

  bench "1 file", [scripts: get_scripts(1)] do
    scripts |> run
  end

  bench "5 files", [scripts: get_scripts(5)] do
    scripts |> run
  end

  bench "10 files", [scripts: get_scripts(10)] do
    scripts |> run
  end

  bench "20 files", [scripts: get_scripts(20)] do
    scripts |> run
  end

  bench "30 files", [scripts: get_scripts(30)] do
    scripts |> run
  end

  defp get_scripts(number) do
    scripts = @sample_script_path
      |> ScriptSources.find
      |> Enum.take(number)
      |> ScriptSources.to_scripts
    scripts
  end

  defp run(scripts) do
    scripts |> Rules.test
  end

end
