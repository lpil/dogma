defmodule Dogma.ScriptSourcesTest do
  use ExUnit.Case, async: true

  alias Dogma.Script
  alias Dogma.ScriptSources

  @fixture_path "test/fixtures/app/"

  describe "find/2" do
    test "exclude the /deps/ directory" do
      paths = ScriptSources.find "."
      refute Enum.any?( paths, &String.starts_with?(&1, "deps/") )
    end

    test "exclude the /_build/ directory" do
      paths = ScriptSources.find "."
      refute Enum.any?( paths, &String.starts_with?(&1, "deps/") )
    end

    test "be the same with or without a trailing slash in given path" do
      with_slash    = ScriptSources.find "test/fixtures/app/"
      without_slash = ScriptSources.find "test/fixtures/app"
      assert with_slash == without_slash
    end

    test "not return files that match given exclude patterns" do
      patterns = [~r(config/), ~r(app/test/), ~r(_build/)]
      paths    = ScriptSources.find( @fixture_path, patterns )
      expected = ~w(
        test/fixtures/app/lib/app.ex
        test/fixtures/app/mix.exs
      )
      assert expected == paths
    end
  end


  describe "to_scripts/1" do
    test "convert each path to a script struct" do
      scripts = ~w(
        test/fixtures/app/lib/app.ex
        test/fixtures/app/lib/app.ex
      ) |> ScriptSources.to_scripts
      assert [
        %Script{ source: "defmodule App do\n  @moduledoc false\nend\n" },
        %Script{ source: "defmodule App do\n  @moduledoc false\nend\n" },
      ] = scripts
    end
  end
end
