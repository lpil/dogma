defmodule Dogma.Rule.VariableNameTest do
  use ShouldI

  alias Dogma.Rule.VariableName
  alias Dogma.Script
  alias Dogma.Error

  defp lint(script) do
    script |> Script.parse!( "foo.ex" ) |> VariableName.test
  end

  should "not error for snake_case names" do
    errors = """
    x       = :ok
    foo     = :ok
    foo_bar = :ok
    """ |> lint
    assert [] == errors
  end

  should "error for non snake_case names" do
    errors = """
    fooBar  = :error
    foo_Bar = :error
    """ |> lint
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
    assert expected_errors == errors
  end

  should "not error with destructuring assignment for snake_case" do
    errors = """
    [foo, bar]       = foo_bar
    {foo_bar}        = foo_bar
    [hd | tl]        = foo_bar
    %{key: foo}      = foo_bar
    "strings" <> foo = foo_bar
    """ |> lint
    assert [] == errors
  end

  should "error with destructuring assignment of structs for non snake_case" do
    errors = """
      assert [
        %Script{ source: sourcePascal },
        %Script{ source: "defmodule App do\n  @moduledoc false\nend\n" },
      ] = predefinedScripts
    """ |> lint
    expected_errors = [
      %Error{
        rule:     VariableName,
        message:  "Variable names should be in snake_case",
        line: 7,
      },]
    assert expected_errors == errors
  end

  should "not error with destructuring assignment of structs for snake_case" do
    errors = """
      assert [
        %Script{ source: source_snake },
        %Script{ source: "defmodule App do\n  @moduledoc false\nend\n" },
      ] = scripts
    """ |> lint
    assert [] == errors
  end

  should "not error with assignment for snake_case 2" do
    errors = """
    def formatters_doc do
      formatters =
        Formatter.formatters
        |> Enum.map(&extract_doc/1)

      default_name = printable_name(Formatter.default_formatter)
      default_id   = String.downcase(default_name)
    end
    """ |> lint
    assert [] == errors
  end

  should "error for pinned variables not in snake_case" do
    errors = """
    ^fooBar = foo_bar
    """ |> lint
    expected_errors = [
      %Error{
        rule:     VariableName,
        message:  "Variable names should be in snake_case",
        line: 1,
      },]
    assert expected_errors == errors
  end

  with "non snake_case variable names in destructuring assignment" do
    should "error for one member lists" do
      errors = """
      [fooBar] = foo_bar
      """ |> lint
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end

    should "error for multi-member lists" do
      errors = """
      [foo, fooBar] = foo_bar
      """ |> lint
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end

    should "error for multi-member lists that include literals" do
      errors = """
      [1, fooBar] = foo_bar
      """ |> lint
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end

    should "error for tuples" do
      errors = """
      {fooBar} = baz
      """ |> lint
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end

    should "error for two-element tuples" do
      errors = """
      {foo, barBaz} = baz
      """ |> lint
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },
      ]
      assert expected_errors == errors
    end

    should "error for tuples inside lists and lists inside tuples" do
      errors = """
      [foo, {barBaz}] = foo_bar
      {3, [fooBar]}  = foo_bar
      """ |> lint
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
        },]
      assert expected_errors == errors
    end

    should "error for maps" do
      errors = """
      %{test: fooBar} = foo_bar
      """ |> lint
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },]
      assert expected_errors == errors
    end

    should "error for head/tail pattern matching" do
      errors = """
      [hEAD | tail] = foo_bar
      """ |> lint
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },]
      assert expected_errors == errors
    end

    should "error for the end of a binary pattern" do
      errors = """
      "test" <> fooBar = foo_bar
      """ |> lint
      expected_errors = [
        %Error{
          rule:     VariableName,
          message:  "Variable names should be in snake_case",
          line: 1,
        },]
      assert expected_errors == errors
    end
  end
end
