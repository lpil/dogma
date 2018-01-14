defmodule Dogma.Rule.PipelineStartTest do
  use RuleCase, for: PipelineStart

  def error_on_line(n) do
    %Error{
      rule: PipelineStart,
      message: "Function Pipe Chains must start with a bare value",
      line: n,
    }
  end

  test "not error with a number start" do
    script = """
    42 |> Integer.to_char_list(16) |> IO.puts
    42 |> IO.puts
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with a string start" do
    script = """
    "A pie"
    |> String.upcase
    |> IO.puts
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with a variable start" do
    script = """
    foo |> String.downcase |> IO.puts
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with an atom start" do
    script = """
    :foo
    |> is_atom
    |> &(&1)
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with a module atom start" do
    script = """
    Foo |> to_string
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with a keyword lookup start" do
    script = """
    map[:foo]
    |> is_atom
    |> IO.inspect
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with a range start" do
    script = """
    1..4
    |> IO.inspect

    a..@some_value
    |> IO.inspect
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "error for non-bare start namespaced functions" do
    script = """
    String.strip("nope") |> String.upcase |> String.downcase
    String.strip("nope") |> String.upcase
    String.strip("nope")
    |> String.upcase
    |> String.downcase
    |> IO.puts
    """ |> Script.parse!("")
    expected_errors = [
      error_on_line(1),
      error_on_line(2),
      error_on_line(3),
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "error for non-bare start functions" do
    script = """
    tl([1, 2, 3]) |> Enum.map(&(&1 + 1)) |> Enum.join
    tl([1, 2, 3]) |> Enum.join
    tl([1, 2, 3])
    |> Enum.map(&(&1 * &1))
    |> Enum.join
    |> IO.puts
    """ |> Script.parse!("")
    expected_errors = [
      error_on_line(1),
      error_on_line(2),
      error_on_line(3),
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "error for non-bare start anonymous functions" do
    script = """
    add_one.([1, 2, 3]) |> IO.inspect
    add_one.([1, 2, 3]) |> Enum.join |> IO.puts
    add_one.([1, 2, 3])
    |> Enum.join
    |> IO.puts
    """ |> Script.parse!("")
    expected_errors = [
      error_on_line(1),
      error_on_line(2),
      error_on_line(3),
    ]
    assert expected_errors == Rule.test( @rule, script )
  end

  test "not error with a pattern match" do
    script = """
    foo = [1, 2, 3] |> tl |> Enum.join
    bar = [3, 2, 1]
    |> tl
    |> Enum.join
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with map values" do
    script = """
    map.key |> Enum.join
    map.key |> Enum.map(&String.upcase/1) |> Enum.join
    map.key
    |> Enum.map(&String.upcase/1)
    |> Enum.join
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error for structs" do
    script = """
    %Struct{} |> do_thing
    %Foo{} |> do_thing |> IO.puts
    %Bar{}
    |> do_thing
    |> IO.puts
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error for maps" do
    script = """
    %{} |> do_thing
    %{ "bar" => 2} |> do_thing |> IO.puts
    %{ foo: 1}
    |> do_thing
    |> IO.puts
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error for tuples" do
    script = """
    {} |> Module.do_thing
    {:ok} |> Module.do_thing |> do_other
    {:ok, foo} |> Module.do_thing |> do_other
    {:ok, bar, 2}
    |> Module.do_thing
    |> do_other
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with a sigil start" do
    script = """
    ~r/\n\n+\z/ |> Regex.run(string)
    ~w(foo bar baz)a |> Enum.map(&to_string/1) |> Enum.join
    ~s(qick brown fox)
    |> String.upcase
    |> IO.puts
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with a module attribute start" do
    script = """
    @attribute |> Enum.join
    @attribute |> Enum.map(&String.upcase/1) |> Enum.join
    @attribute
    |> Enum.map(&String.upcase/1)
    |> Enum.join
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with a zero-arity function start" do
    script = """
    self() |> send(:hello)
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with an interpolated string start" do
    script = ~S"""
    "A #{baked_good}" |> String.upcase |> IO.puts
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with binary start" do
    script = ~S"""
    << thing::utf8 >> |> String.upcase |> IO.puts
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with unquote start" do
    script = ~S"""
    quote do
      unquote(foo)
      |> bar
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with ++ start" do
    script = ~S"""
    list_a
    ++ list_b
    |> wrap()
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "not error with ++ in middle" do
    script = ~S"""
    [1]
    |> bobble()
    ++ thingies
    |> rebobble()
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  test "errors with non-bare ++ start" do
    script = ~S"""
    bobble(:widget)
    ++ thingies
    |> rebobble()
    """ |> Script.parse!("")
    assert [error_on_line(1)] == Rule.test( @rule, script )
  end

  test "not error for value placeholders" do
    script = ~S"""
    &1
    |> bobble()
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end
end
