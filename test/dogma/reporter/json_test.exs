defmodule Dogma.Reporter.JSONTest do
  use ShouldI

  import ExUnit.CaptureIO

  alias Dogma.Reporter.JSON
  alias Dogma.Script
  alias Dogma.Error

  having "no errors" do
    should "return JSON of files with no errors" do
      scripts = [
        %Script{ path: "foo.ex", errors: [] },
        %Script{ path: "bar.ex", errors: [] }
      ]

      for script <- scripts do
        _ = capture_io(fn ->
          {:ok, []} = JSON.handle_event({:script_tested,  script}, [])
        end)
      end
      result = capture_io(fn ->
        {:ok, []} = JSON.handle_event({:finished,  scripts}, [])
      end)
      json = Poison.decode!(result)

      test_system_info(json)

      assert json["files"] == [
        %{"errors" => [], "path" => "foo.ex"},
        %{"errors" => [], "path" => "bar.ex"}
      ]

      assert json["summary"] == %{
        "offense_count" => 0,
        "inspected_file_count" => 2
      }
    end
  end

  having "some errors" do
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

      result = capture_io(fn -> JSON.handle_event({:finished, scripts}, []) end)
      json = Poison.decode!(result)

      test_system_info(json)

      assert json["files"] == [
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

      assert json["summary"] == %{
        "offense_count" => 2,
        "inspected_file_count" => 2
      }
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
