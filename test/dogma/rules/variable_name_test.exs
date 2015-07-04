defmodule Dogma.Rules.VariableNameTest do
  use DogmaTest.Helper

  alias Dogma.Rules.VariableName
  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.parse( "foo.ex" ) |> VariableName.test
  end

  with "valid names" do
    setup context do
      script = """
      x       = :ok
      foo     = :ok
      foo_bar = :ok
      """ |> test
      %{ script: script }
    end
    should_register_no_errors
  end

  with "invalid names" do
    setup context do
      script = """
      fooBar  = :error
      foo_Bar = :error
      """ |> test
      %{ script: script }
    end
    should_register_errors [
      %Error{
        rule:     VariableName,
        message:  "Variable names should be in snake_case",
        position: 2,
      },
      %Error{
        rule:     VariableName,
        message:  "Variable names should be in snake_case",
        position: 1,
      },
    ]
  end
end
