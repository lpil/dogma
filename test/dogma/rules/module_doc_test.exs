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
      script = """
      defmodule VeryGood do
        @moduledoc "Lots of good info here"
      end
      """ |> test
      %{ script: script }
    end
    should_register_no_errors

    with "nested modules" do
      setup context do
        script = """
        defmodule VeryGood do
          @moduledoc "Lots of good info here"
          defmodule AlsoGood do
            @moduledoc "And even more here!"
          end
        end
        """ |> test
        %{ script: script }
      end
      should_register_no_errors
    end
  end

  with "a module missing a module doc" do
    setup context do
      script = """
      defmodule NotGood do
      end
      """ |> test
      %{ script: script }
    end
    should_register_errors [
      %Error{
        rule: ModuleDoc,
        message: "Module without a @moduledoc detected.",
        position: 1,
      }
    ]
  end

  with "a nested module missing a module doc" do
    setup context do
      script = """
      defmodule VeryGood do
        @moduledoc "Lots of good info here"
        defmodule NotGood do
        end
      end
      """ |> test
      %{ script: script }
    end
    should_register_errors [
      %Error{
        rule: ModuleDoc,
        message: "Module without a @moduledoc detected.",
        position: 3,
      }
    ]
  end

  with "a parent module missing a module doc" do
    setup context do
      script = """
      defmodule NotGood do
        defmodule VeryGood do
          @moduledoc "Lots of good info here"
        end
      end
      """ |> test
      %{ script: script }
    end
    should_register_errors [
      %Error{
        rule: ModuleDoc,
        message: "Module without a @moduledoc detected.",
        position: 1,
      }
    ]
  end
end
