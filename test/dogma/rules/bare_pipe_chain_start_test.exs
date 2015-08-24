defmodule Dogma.Rules.BarePipeChainStartTest do
  use DogmaTest.Helper

  alias Dogma.Rules.BarePipeChainStart
  alias Dogma.Script
  alias Dogma.Error

  def test(script) do
    script
    |> Script.parse("foo.ex")
    |> BarePipeChainStart.test
  end

  with "a bare start value" do
    setup context do
      errors = """
      42 |> Integer.to_char_list(16) |> IO.puts

      42 |> IO.puts

      "A pie"
      |> String.upcase
      |> IO.puts

      foo |> String.downcase |> IO.puts

      :foo
      |> is_atom
      |> &(&1)
      """ |> test
      %{errors: errors}
    end

    should_register_no_errors
  end

  with "namespaced functions" do
    setup context do
      errors = """
      String.strip("nope") |> String.upcase |> String.downcase
      String.strip("nope") |> String.upcase
      String.strip("nope")
      |> String.upcase
      |> String.downcase
      |> IO.puts
      """ |> test
      %{errors: errors}
    end

    should_register_errors [
      %Error{
        rule: BarePipeChainStart,
        message: "Function Pipe Chains must start with a bare value",
        line: 1
      },
      %Error{
        rule: BarePipeChainStart,
        message: "Function Pipe Chains must start with a bare value",
        line: 2
      },
      %Error{
        rule: BarePipeChainStart,
        message: "Function Pipe Chains must start with a bare value",
        line: 3
      }
    ]
  end

  with "a bare function" do
    setup context do
      errors = """
      tl([1, 2, 3]) |> Enum.map(&(&1 + 1)) |> Enum.join
      tl([1, 2, 3]) |> Enum.join
      tl([1, 2, 3])
      |> Enum.map(&(&1 * &1))
      |> Enum.join
      |> IO.puts
      """ |> test
      %{errors: errors}
    end

    should_register_errors [
      %Error{
        rule: BarePipeChainStart,
        message: "Function Pipe Chains must start with a bare value",
        line: 1
      },
      %Error{
        rule: BarePipeChainStart,
        message: "Function Pipe Chains must start with a bare value",
        line: 2
      },
      %Error{
        rule: BarePipeChainStart,
        message: "Function Pipe Chains must start with a bare value",
        line: 3
      }
    ]
  end

  with "an anonymous function" do
    setup context do
      errors = """
      add_one.([1, 2, 3]) |> IO.inspect
      add_one.([1, 2, 3]) |> Enum.join |> IO.puts
      add_one.([1, 2, 3])
      |> Enum.join
      |> IO.puts
      """ |> test

      %{errors: errors}
    end

    should_register_errors [
      %Error{
        rule: BarePipeChainStart,
        message: "Function Pipe Chains must start with a bare value",
        line: 1
      },
      %Error{
        rule: BarePipeChainStart,
        message: "Function Pipe Chains must start with a bare value",
        line: 2
      },
      %Error{
        rule: BarePipeChainStart,
        message: "Function Pipe Chains must start with a bare value",
        line: 3
      }
    ]
  end

  with "a pattern match do" do
    setup context do
      errors = """
      foo = [1, 2, 3] |> tl |> Enum.join
      bar = [3, 2, 1]
      |> tl
      |> Enum.join
      """ |> test
      %{errors: errors}
    end

    should_register_no_errors
  end

  with "map values" do
    setup context do
      errors = """
      map.key |> Enum.join
      map.key |> Enum.map(&String.upcase/1) |> Enum.join
      map.key
      |> Enum.map(&String.upcase/1)
      |> Enum.join
      """ |> test
      %{errors: errors}
    end

    should_register_no_errors
  end

  with "maps and structs" do
    setup context do
      errors = """
      %Struct{} |> do_thing
      %Struct{} |> do_thing |> IO.puts
      %Struct{}
      |> do_thing
      |> IO.puts
      %{} |> do_thing
      %{} |> do_thing |> IO.puts
      %{}
      |> do_thing
      |> IO.puts
      """ |> test
      %{errors: errors}
    end

    should_register_no_errors
  end

  with "tuples" do
    setup context do
      errors = """
      {:ok, foo} |> Module.do_thing
      {:ok, foo} |> Module.do_thing |> do_other
      {:ok, foo}
      |> Module.do_thing
      |> do_other
      """ |> test
      %{errors: errors}
    end

    should_register_no_errors
  end

  with "large tuples" do
    setup context do
      errors = """
      {:ok, foo, bar} |> Module.do_thing
      {:ok, foo, bar} |> Module.do_thing |> do_other
      {:ok, foo, bar}
      |> Module.do_thing
      |> do_other
      """ |> test
      %{errors: errors}
    end

    should_register_no_errors
  end

  with "sigils" do
    setup context do
      errors = """
      ~r/\n\n+\z/ |> Regex.run(string)
      ~w(foo bar baz)a |> Enum.map(&to_string/1) |> Enum.join
      ~s(qick brown fox)
      |> String.upcase
      |> IO.puts
      """ |> test
      %{errors: errors}
    end

    should_register_no_errors
  end

  with "module attributes" do
    setup context do
      errors = """
      @attribute |> Enum.join
      @attribute |> Enum.map(&String.upcase/1) |> Enum.join
      @attribute
      |> Enum.map(&String.upcase/1)
      |> Enum.join
      """ |> test
      %{errors: errors}
    end

    should_register_no_errors
  end
end
