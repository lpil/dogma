defmodule Dogma.Formatter.JSONTest do
  use ShouldI

  alias Dogma.Formatter.JSON
  alias Dogma.Script
  alias Dogma.Error

  with ".start" do
    with "no files to list" do
      should "print nothing" do
        assert JSON.start([]) == ""
      end
    end

    with "some files to lint" do
      should "print nothing" do
        script = [%Script{}, %Script{}, %Script{}]
        assert JSON.start(script) == ""
      end
    end
  end

  with ".script" do
    with "no errors" do
      should "print nothing" do
        script = %Script{ errors: [] }
        assert JSON.script(script) == ""
      end
    end

    with "some errors" do
      should "print nothing" do
        script = %Script{ errors: [%Error{}] }
        assert JSON.script(script) == ""
      end
    end
  end

  with ".finish" do
    with "no errors" do
      should "return JSON of files with no errors" do
        scripts = [
          %Script{ path: "foo.ex", errors: [] },
          %Script{ path: "bar.ex", errors: [] }
        ]

        result = scripts |> JSON.finish |> Poison.decode!

        test_system_info(result)

        assert result["files"] == [
          %{"errors" => [], "path" => "foo.ex"},
          %{"errors" => [], "path" => "bar.ex"}
        ]

        assert result["summary"] == %{
          "offense_count" => 0,
          "inspected_file_count" => 2
        }
      end
    end

    with "some errors" do
      should "return JSON of files with some errors" do
        errors = [
          %Error{
            line: 1,
            rule: Dogma.Rules.ModuleDoc,
            message: "Module without a @moduledoc detected"
          },
          %Error{
            line: 14,
            rule: Dogma.Rules.ComparisonToBoolean,
            message: "Comparison to a boolean is pointless"
          }
        ]

        scripts = [
          %Script{ path: "foo.ex", errors: [] },
          %Script{ path: "bar.ex", errors: errors }
        ]

        result = scripts |> JSON.finish |> Poison.decode!

        test_system_info(result)

        assert result["files"] == [
          %{"path" => "foo.ex", "errors" => []},
          %{"path" => "bar.ex", "errors" => [
              %{
                "line" => 1,
                "rule" => "ModuleDoc",
                "message" => "Module without a @moduledoc detected"
              },
              %{
                "line" => 14,
                "rule" => "ComparisonToBoolean",
                "message" => "Comparison to a boolean is pointless"
              }
            ]}
        ]

        assert result["summary"] == %{
          "offense_count" => 2,
          "inspected_file_count" => 2
        }
      end
    end
  end

  defp test_system_info(%{"metadata" => metadata}) do
    assert metadata == %{
      "dogma_version"       => Dogma.version,
      "elixir_version"      => System.version,
      "erlang_version"      => erlang_version,
      "system_architecture" => system_architecture
    }
  end

  defp erlang_version do
    :system_version
    |> :erlang.system_info
    |> to_string
  end

  defp system_architecture do
    :system_architecture
    |> :erlang.system_info
    |> to_string
  end
end
