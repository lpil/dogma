defmodule Dogma.Rules.ModuleAttributeNameTest do
  use DogmaTest.Helper

  alias Dogma.Rules.ModuleAttributeName
  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.parse( "foo.ex" ) |> ModuleAttributeName.test
  end

  with "valid module attribute names" do
    setup context do
      errors = """
      defmodule HelloWorld do
        @hello_world 1
        @hello 2
      end
      """ |> test
      %{ errors: errors }
    end
    should_register_no_errors
  end

  with "a camelCase module attribute name" do
    setup context do
      errors = """
      defmodule :snake_case do
        @helloWorld 1
      end
      """ |> test
      %{ errors: errors }
    end
    should_register_errors [
      %Error{
        rule:     ModuleAttributeName,
        message:  "Module attribute names should be in snake_case",
        position: 2,
      }
    ]
  end

end
