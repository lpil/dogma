defmodule Dogma.Rule.ModuleAttributeNameTest do
  use ShouldI

  alias Dogma.Rule.ModuleAttributeName
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse!( "foo.ex" ) |> ModuleAttributeName.test
  end

  should "not error with snake_case module attribute names" do
    errors = """
    defmodule HelloWorld do
      @hello_world 1
      @hello 2
    end
    """ |> test
    assert [] == errors
  end

  should "error for a camelCase module attribute name" do
    errors = """
    defmodule SnakeCase do
      @helloWorld 1
      @hello_World 1
    end
    """ |> test
    expected_errors = [
      %Error{
        rule:     ModuleAttributeName,
        message:  "Module attribute names should be in snake_case",
        line: 3,
      },
      %Error{
        rule:     ModuleAttributeName,
        message:  "Module attribute names should be in snake_case",
        line: 2,
      },
    ]
    assert expected_errors == errors
  end
end
