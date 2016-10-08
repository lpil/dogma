defmodule Dogma.Rule.ModuleNameTest do
  use RuleCase, for: ModuleName

  test "not error with a valid module name" do
    script = """
    defmodule HelloWorld do
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "a valid module name as a symbol" do
    script = """
    defmodule :HelloWorld do
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "a valid nested module name" do
    script = """
    defmodule Hello.World do
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "nested modules with valid names" do
    script = """
    defmodule Hello do
      defmodule There do
        defmodule World do
        end
      end
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "a snake_case module name" do
    script = """
    defmodule Snake_case do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     ModuleName,
        message:  "Module names should be in PascalCase",
        line: 1,
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "a snake_case symbol module name" do
    script = """
    defmodule :snake_case do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     ModuleName,
        message:  "Module names should be in PascalCase",
        line: 1,
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "a snake_case 2 part module name" do
    script = """
    defmodule Hello.There_world do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     ModuleName,
        message:  "Module names should be in PascalCase",
        line: 1,
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "a nested snake_case name" do
    script = """
    defmodule Hello do
      defmodule I_am_interrupting do
        defmodule World do
        end
      end
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     ModuleName,
        message:  "Module names should be in PascalCase",
        line: 2,
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "a non-capitalised 2 part name" do
    script = """
    defmodule :"Hello.world" do
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     ModuleName,
        message:  "Module names should be in PascalCase",
        line: 1,
      }
    ]
    assert expected_errors == Rule.test( @rule, script )
  end
end
