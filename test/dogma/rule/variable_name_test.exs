defmodule Dogma.Rule.VariableNameTest do
  use RuleCase, for: VariableName

  should "not error for snake_case names" do
    script = """
    x       = :ok
    foo     = :ok
    foo_bar = :ok
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error for non snake_case names" do
    script = """
    fooBar  = :error
    foo_Bar = :error
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     VariableName,
        message:  "Variable names should be in snake_case",
        line: 2,
      },
      %Error{
        rule:     VariableName,
        message:  "Variable names should be in snake_case",
        line: 1,
      },
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  should "not error with destructuring assignment for snake_case" do
    script = """
    [foo, bar]       = foo_bar
    {foo_bar}        = foo_bar
    [hd | tl]        = foo_bar
    %{key: foo}      = foo_bar
    "strings" <> foo = foo_bar
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error with destructuring assignment of structs for non snake_case" do
    script = ~S"""
      [
        %Script{ source: sourcePascal },
        %Script{ source: "defmodule App do\n  @moduledoc false\nend\n" },
      ] = predefinedScripts
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:    VariableName,
        message: "Variable names should be in snake_case",
        line: 4,
      },
      %Error{
        rule:    VariableName,
        message: "Variable names should be in snake_case",
        line: 2,
      },
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  should "not error with destructuring assignment of structs for snake_case" do
    script = """
      assert [
        %Script{ source: source_snake },
        %Script{ source: "defmodule App do\n  @moduledoc false\nend\n" },
      ] = scripts
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error with assignment for snake_case 2" do
    script = """
    def formatters_doc do
      formatters =
        Formatter.formatters
        |> Enum.map(&extract_doc/1)

      default_name = printable_name(Formatter.default_formatter)
      default_id   = String.downcase(default_name)
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error for pinned variables not in snake_case" do
    script = """
    ^fooBar = foo_bar
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     VariableName,
        message:  "Variable names should be in snake_case",
        line: 1,
      }]
    assert expected_errors == Rule.test( @rule, script )
  end

  having "non snake_case variable names in destructuring assignment" do
    should "error for one member lists" do
      script = """
      [fooBar] = foo_bar
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error for multi-member lists" do
      script = """
      [foo, fooBar] = foo_bar
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error for multi-member lists that include literals" do
      script = """
      [1, fooBar] = foo_bar
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error for tuples" do
      script = """
      {fooBar} = baz
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error for two-element tuples" do
      script = """
      {foo, barBaz} = baz
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error for tuples inside lists and lists inside tuples" do
      script = """
      [foo, {barBaz}] = foo_bar
      {3, [fooBar]}  = foo_bar
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 2,
        },
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error for maps" do
      script = """
      %{test: fooBar} = foo_bar
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error for head/tail pattern matching" do
      script = """
      [hEAD | tail] = foo_bar
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "error for the end of a binary pattern" do
      script = """
      "test" <> fooBar = foo_bar
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == Rule.test( @rule, script )
    end

    should "find all script when there are several" do
      script = """
      %{some_value: someValue, other_value: otherValue} = load_something()
      """ |> Script.parse!("")
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == Rule.test( @rule, script )
    end
  end

  should "not error for module attribute assignments" do
    script = """
    x = @hello
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "not error for operators" do
    script = """
    count = a + b * c - d / e
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end
end
