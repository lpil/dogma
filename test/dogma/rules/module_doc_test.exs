defmodule Dogma.Rules.ModuleDocTest do
  use DogmaTest.Helper

  alias Dogma.Rules.ModuleDoc
  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script |> Script.parse( "foo.ex" ) |> ModuleDoc.test
  end


  with "module docs" do
    setup context do
      errors = """
      defmodule VeryGood do
        @moduledoc "Lots of good info here"
      end
      """ |> test
      %{ errors: errors }
    end
    should_register_no_errors

    with "nested modules" do
      setup context do
        errors = """
        defmodule VeryGood do
          @moduledoc "Lots of good info here"
          defmodule AlsoGood do
            @moduledoc "And even more here!"
          end
        end
        """ |> test
        %{ errors: errors }
      end
      should_register_no_errors
    end
  end

  with "a module missing a module doc" do
    setup context do
      errors = """
      defmodule NotGood do
      end
      """ |> test
      %{ errors: errors }
    end
    should_register_errors [
      %Error{
        rule: ModuleDoc,
        message: "Module without a @moduledoc detected.",
        line: 1,
      }
    ]
  end

  with "a nested module missing a module doc" do
    setup context do
      errors = """
      defmodule VeryGood do
        @moduledoc "Lots of good info here"
        defmodule NotGood do
        end
      end
      """ |> test
      %{ errors: errors }
    end
    should_register_errors [
      %Error{
        rule: ModuleDoc,
        message: "Module without a @moduledoc detected.",
        line: 3,
      }
    ]
  end

  with "a parent module missing a module doc" do
    setup context do
      errors = """
      defmodule NotGood do
        defmodule VeryGood do
          @moduledoc "Lots of good info here"
        end
      end
      """ |> test
      %{ errors: errors }
    end
    should_register_errors [
      %Error{
        rule: ModuleDoc,
        message: "Module without a @moduledoc detected.",
        line: 1,
      }
    ]
  end

  with "an exs file (meaning it's to be skipped)" do
    setup context do
      errors = """
      defmodule NotGood do
      end
      """ |> Script.parse( "foo.exs" ) |> ModuleDoc.test
      %{ errors: errors }
    end
    should_register_no_errors
  end
end
