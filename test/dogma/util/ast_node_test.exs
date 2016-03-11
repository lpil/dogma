defmodule Dogma.Util.ASTTest do
  use ShouldI

  alias Dogma.Util.AST

  doctest Dogma.Util.AST

  having "literal?/1" do
    should "be true for atom literals" do
      atom = quote do: :foo
      assert AST.literal?(atom)
    end

    should "be true for string literals" do
      string = quote do: "foo"
      assert AST.literal?(string)
    end

    should "be true for booleans" do
      bool = quote do: false
      assert AST.literal?(bool)
    end

    should "be true for numbers" do
      number = quote do: 1.3
      assert AST.literal?(number)
    end

    should "be true for lists" do
      list = quote do: ["foo", "bar", "baz"]
      assert AST.literal?(list)
    end

    should "be true for tuples" do
      tuple = quote do: {4}
      assert AST.literal?(tuple)
    end

    should "be true for tuples with two elements" do
      tuple = quote do: {4, 5}
      assert AST.literal?(tuple)
    end

    should "be true for maps" do
      map = quote do: %{foo: :bar}
      assert AST.literal?(map)
    end

    should "be true for sigil strings" do
      string = quote do: ~s(foo)
      without_escapes = quote do: ~S(foo)
      assert AST.literal?(string)
      assert AST.literal?(without_escapes)
    end

    should "be true for word lists" do
      word_list = quote do: ~w(foo bar)
      assert AST.literal?(word_list)
    end

    should "be true for regex" do
      regex = quote do: ~r/test/
      assert AST.literal?(regex)
    end

    should "be true for custom sigils" do
      sigil = quote do: ~p(wow)
      assert AST.literal?(sigil)
    end

    should "be false for variables/functions" do
      variable = quote do: foo
      refute AST.literal?(variable)
    end

    should "be false for module names" do
      module = quote do: TestModuleName
      refute AST.literal?(module)
    end
  end
end
