defmodule Dogma.Util.ASTNodeTest do
  use ShouldI

  alias Dogma.Util.ASTNode

  doctest Dogma.Util.ASTNode

  with "literal?/1" do
    should "be true for atom literals" do
      atom = quote do: :foo
      assert ASTNode.literal?(atom)
    end

    should "be true for string literals" do
      string = quote do: "foo"
      assert ASTNode.literal?(string)
    end

    should "be true for booleans" do
      bool = quote do: false
      assert ASTNode.literal?(bool)
    end

    should "be true for numbers" do
      number = quote do: 1.3
      assert ASTNode.literal?(number)
    end

    should "be true for lists" do
      list = quote do: ["foo", "bar", "baz"]
      assert ASTNode.literal?(list)
    end

    should "be true for tuples" do
      tuple = quote do: {4}
      assert ASTNode.literal?(tuple)
    end

    should "be true for tuples with two elements" do
      tuple = quote do: {4,5}
      assert ASTNode.literal?(tuple)
    end

    should "be true for maps" do
      map = quote do: %{foo: :bar}
      assert ASTNode.literal?(map)
    end

    should "be true for sigil strings" do
      string = quote do: ~s(foo)
      without_escapes = quote do: ~S(foo)
      assert ASTNode.literal?(string)
      assert ASTNode.literal?(without_escapes)
    end

    should "be true for word lists" do
      word_list = quote do: ~w(foo bar)
      assert ASTNode.literal?(word_list)
    end

    should "be false for variables/functions" do
      variable = quote do: foo
      refute ASTNode.literal?(variable)
    end

    should "be false for module names" do
      module = quote do: TestModuleName
      refute ASTNode.literal?(module)
    end
  end
end
