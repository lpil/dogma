defmodule Dogma.Rules.BarePipeChainStartTest do
  use ShouldI

  alias Dogma.Rules.BarePipeChainStart
  alias Dogma.Script
  alias Dogma.Error

  defp test(script) do
    script
    |> Script.parse!("foo.ex")
    |> BarePipeChainStart.test
  end

  should "not error with a number start" do
    errors = """
    42 |> Integer.to_char_list(16) |> IO.puts
    42 |> IO.puts
    """ |> test
    assert [] == errors
  end


  should "not error with a string start" do
    errors = """
    "A pie"
    |> String.upcase
    |> IO.puts
    """ |> test
    assert [] == errors
  end

  should "not error with a variable start" do
    errors = """
    foo |> String.downcase |> IO.puts
    """ |> test
    assert [] == errors
  end

  should "not error with an atom start" do
    errors = """
    :foo
    |> is_atom
    |> &(&1)
    """ |> test
    assert [] == errors
  end

  should "not error with a module atom start" do
    errors = """
    Foo |> to_string
    """ |> test
    assert [] == errors
  end

  should "error for non-bare start namespaced functions" do
    errors = """
    String.strip("nope") |> String.upcase |> String.downcase
    String.strip("nope") |> String.upcase
    String.strip("nope")
    |> String.upcase
    |> String.downcase
    |> IO.puts
    """ |> test
    expected_errors = [
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
    assert expected_errors == errors
  end

  should "error for non-bare start functions" do
    errors = """
    tl([1, 2, 3]) |> Enum.map(&(&1 + 1)) |> Enum.join
    tl([1, 2, 3]) |> Enum.join
    tl([1, 2, 3])
    |> Enum.map(&(&1 * &1))
    |> Enum.join
    |> IO.puts
    """ |> test
    expected_errors = [
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
    assert expected_errors == errors
  end

  should "error for non-bare start anonymous functions" do
    errors = """
    add_one.([1, 2, 3]) |> IO.inspect
    add_one.([1, 2, 3]) |> Enum.join |> IO.puts
    add_one.([1, 2, 3])
    |> Enum.join
    |> IO.puts
    """ |> test
    expected_errors = [
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
    assert expected_errors == errors
  end

  should "not error with a pattern match" do
    errors = """
    foo = [1, 2, 3] |> tl |> Enum.join
    bar = [3, 2, 1]
    |> tl
    |> Enum.join
    """ |> test
    assert [] == errors
  end

  should "not error with map values" do
    errors = """
    map.key |> Enum.join
    map.key |> Enum.map(&String.upcase/1) |> Enum.join
    map.key
    |> Enum.map(&String.upcase/1)
    |> Enum.join
    """ |> test
    assert [] == errors
  end

  should "not error for structs" do
    errors = """
    %Struct{} |> do_thing
    %Foo{} |> do_thing |> IO.puts
    %Bar{}
    |> do_thing
    |> IO.puts
    """ |> test
    assert [] == errors
  end

  should "not error for maps" do
    errors = """
    %{} |> do_thing
    %{ "bar" => 2} |> do_thing |> IO.puts
    %{ foo: 1}
    |> do_thing
    |> IO.puts
    """ |> test
    assert [] == errors
  end

  should "not error for tuples" do
    errors = """
    {} |> Module.do_thing
    {:ok} |> Module.do_thing |> do_other
    {:ok, foo} |> Module.do_thing |> do_other
    {:ok, bar, 2}
    |> Module.do_thing
    |> do_other
    """ |> test
    assert [] == errors
  end


  should "not error with a sigil start" do
    errors = """
    ~r/\n\n+\z/ |> Regex.run(string)
    ~w(foo bar baz)a |> Enum.map(&to_string/1) |> Enum.join
    ~s(qick brown fox)
    |> String.upcase
    |> IO.puts
    """ |> test
    assert [] == errors
  end

  should "not error with a module attribute start" do
    errors = """
    @attribute |> Enum.join
    @attribute |> Enum.map(&String.upcase/1) |> Enum.join
    @attribute
    |> Enum.map(&String.upcase/1)
    |> Enum.join
    """ |> test
    assert [] == errors
  end

  should "not error with an interpolated string start" do
    errors = ~S"""
    "A #{baked_good}" |> String.upcase |> IO.puts
    """ |> test
    assert [] == errors
  end

  should "not error with binary start" do
    errors = ~S"""
    << thing::utf8 >> |> String.upcase |> IO.puts
    """ |> test
    assert [] == errors
  end
end
