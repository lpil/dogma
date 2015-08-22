defmodule Dogma.Rules.PredicateNameTest do
  use DogmaTest.Helper

  alias Dogma.Rules.PredicateName
  alias Dogma.Script
  alias Dogma.Error

  with "bad predicates" do
    setup context do
      errors = [
        """
        def is_naughty?(arg) do
          true
        end
        """,
        """
        defp is_bad?() do
          true
        end
        """
      ]
      |> Enum.join( "\n" )
      |> Script.parse( "foo.ex" )
      |> PredicateName.test
      %{ errors: errors }
    end
    should_register_errors [
      %Error{
        rule: PredicateName,
        message: "Favour `bad?` over `is_bad?`",
        position: 5,
      },
      %Error{
        rule: PredicateName,
        message: "Favour `naughty?` over `is_naughty?`",
        position: 1,
      },
    ]
  end

  with "good predicates" do
    setup context do
      errors = [
        """
        def nice?(arg) do
          true
        end
        """,
        """
        defp is_nice() do
          true
        end
        """
      ]
      |> Enum.join( "\n" )
      |> Script.parse( "foo.ex" )
      |> PredicateName.test
      %{ errors: errors }
    end
    should_register_no_errors
  end
end
