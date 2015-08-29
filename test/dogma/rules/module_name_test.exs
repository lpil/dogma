defmodule Dogma.Rules.ModuleNameTest do
  use ShouldI

  alias Dogma.Rules.ModuleName
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse!( "foo.ex" ) |> ModuleName.test
  end

  should "not error with a valid module name" do
    errors = """
    defmodule HelloWorld do
    end
    """ |> test
    assert [] == errors
  end

  should "a valid module name as a symbol" do
    errors = """
    defmodule :HelloWorld do
    end
    """ |> test
    assert [] == errors
  end

  should "a valid nested module name" do
    errors = """
    defmodule Hello.World do
    end
    """ |> test
    assert [] == errors
  end

  should "nested modules with valid names" do
    errors = """
    defmodule Hello do
      defmodule There do
        defmodule World do
        end
      end
    end
    """ |> test
    assert [] == errors
  end


  should "a snake_case module name" do
    errors = """
    defmodule Snake_case do
    end
    """ |> test
    expected_errors = [
      %Error{
        rule:     ModuleName,
        message:  "Module names should be in PascalCase",
        line: 1,
      }
    ]
    assert expected_errors == errors
  end

  should "a snake_case symbol module name" do
    errors = """
    defmodule :snake_case do
    end
    """ |> test
    expected_errors = [
      %Error{
        rule:     ModuleName,
        message:  "Module names should be in PascalCase",
        line: 1,
      }
    ]
    assert expected_errors == errors
  end

  should "a snake_case 2 part module name" do
    errors = """
    defmodule Hello.There_world do
    end
    """ |> test
    expected_errors = [
      %Error{
        rule:     ModuleName,
        message:  "Module names should be in PascalCase",
        line: 1,
      }
    ]
    assert expected_errors == errors
  end

  should "a nested snake_case name" do
    errors = """
    defmodule Hello do
      defmodule I_am_interrupting do
        defmodule World do
        end
      end
    end
    """ |> test
    expected_errors = [
      %Error{
        rule:     ModuleName,
        message:  "Module names should be in PascalCase",
        line: 2,
      }
    ]
    assert expected_errors == errors
  end


  should "a non-capitalised 2 part name" do
    errors = """
    defmodule :"Hello.world" do
    end
    """ |> test
    expected_errors = [
      %Error{
        rule:     ModuleName,
        message:  "Module names should be in PascalCase",
        line: 1,
      }
    ]
    assert expected_errors == errors
  end
end
