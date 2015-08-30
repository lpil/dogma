defmodule Dogma.Rules.ModuleDocTest do
  use ShouldI

  alias Dogma.Rules.ModuleDoc
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script |> Script.parse!( "foo.ex" ) |> ModuleDoc.test
  end


  with "module docs" do
    should "not error" do
      errors = """
      defmodule VeryGood do
        @moduledoc "Lots of good info here"
      end
      """ |> test
      assert [] == errors
    end

    should "not error with nested modules" do
      errors = """
      defmodule VeryGood do
        @moduledoc "Lots of good info here"
        defmodule AlsoGood do
          @moduledoc "And even more here!"
        end
      end
      """ |> test
      assert [] == errors
    end
  end

  should "error for a module missing a module doc" do
    errors = """
    defmodule NotGood do
    end
    """ |> test
    expected_errors = [
      %Error{
        rule: ModuleDoc,
        message: "Module NotGood is missing a @moduledoc.",
        line: 1,
      }
    ]
    assert expected_errors == errors
  end

  should "print the module name correctly when it is namespaced" do
    errors = """
    defmodule NotGood.AtAll do
    end
    """ |> test
    expected_errors = [
      %Error{
        rule: ModuleDoc,
        message: "Module NotGood.AtAll is missing a @moduledoc.",
        line: 1,
      }
    ]

    assert expected_errors == errors
  end

  should "error for a nested module missing a module doc" do
    errors = """
    defmodule VeryGood do
      @moduledoc "Lots of good info here"
      defmodule NotGood do
      end
    end
    """ |> test
    expected_errors = [
      %Error{
        rule: ModuleDoc,
        message: "Module NotGood is missing a @moduledoc.",
        line: 3,
      }
    ]
    assert expected_errors == errors
  end

  should "error for a parent module missing a module doc" do
    errors = """
    defmodule NotGood do
      defmodule VeryGood do
        @moduledoc "Lots of good info here"
      end
    end
    """ |> test
    expected_errors = [
      %Error{
        rule: ModuleDoc,
        message: "Module NotGood is missing a @moduledoc.",
        line: 1,
      }
    ]
    assert expected_errors == errors
  end

  should "not error for an exs file (exs is skipped)" do
    errors = """
    defmodule NotGood do
    end
    """ |> Script.parse!( "foo.exs" ) |> ModuleDoc.test
    assert [] == errors
  end
end
