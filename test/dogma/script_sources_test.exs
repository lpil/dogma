defmodule Dogma.ScriptSourcesTest do
  use ShouldI

  alias Dogma.Script
  alias Dogma.ScriptSources

  with "find/1" do
    should "exclude the /deps/ directory" do
      paths = ScriptSources.find "."
      refute Enum.any?( paths, &String.starts_with?(&1, "deps/") )
    end

    with "a given path" do
      setup context do
        %{
          paths: ~w(
            test/fixtures/app/config/config.exs
            test/fixtures/app/lib/app.ex
            test/fixtures/app/mix.exs
            test/fixtures/app/test/app_test.exs
            test/fixtures/app/test/test_helper.exs
          )
        }
      end

      should "be happy with a trailing slash", expected do
        paths = ScriptSources.find "test/fixtures/app/"
        assert paths == expected.paths
      end

      should "be happy without a trailing slash", expected do
        paths = ScriptSources.find "test/fixtures/app"
        assert paths == expected.paths
      end
    end
  end


  with "to_scripts/1" do
    should "convert each path to a script struct" do
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
