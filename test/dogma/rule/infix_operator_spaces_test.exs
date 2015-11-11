defmodule Dogma.Rule.InfixOperatorSpacesTest do
  use ShouldI

  alias Dogma.Rule.InfixOperatorSpaces
  alias Dogma.Script
  alias Dogma.Error

  defp lint(script) do
    script |> Script.parse!( "foo.ex" ) |> InfixOperatorSpaces.test
  end

  should "not error with spaces around infix operators" do
    errors = """
    1 < 2 && 2 >= 3 || 4 > 7 || 3 <= 9
    2 - 1 * 3 / 4 + 5
    a = 1
    b ==
      5
    %{:c => 1}
    """ |> lint
    assert [] == errors
  end

  should "not error with unary operators" do
    errors = """
    -1
    b = -3
    !c
    """ |> lint
    assert [] == errors
  end

  should "error without spaces before infix operators" do
    errors = """
    1+ 2
    3* 4
    1= 1
    a<= b
    c&& d
    e|| f
    g<> h
    i== 2
    x + y+ z
    %{:j=> 1}
    k==
      1
    """ |> lint
    expected_errors = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] |> Enum.map fn line ->
      %Error{
        rule: InfixOperatorSpaces,
        message: "Infix operators should be surrounded by whitespace.",
        line: line
      }
    end
    assert expected_errors == errors
  end

  should "error without spaces after infix operators" do
    errors = """
    1 +2
    3 *4
    1 =1
    a <=b
    c &&d
    e ||f
    g <>h
    i ==2
    x + y +z
    %{:j =>1}
    k
      ==1
    """ |> lint
    expected_errors = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12] |> Enum.map fn line ->
      %Error{
        rule: InfixOperatorSpaces,
        message: "Infix operators should be surrounded by whitespace.",
        line: line
      }
    end
    assert expected_errors == errors
  end

end
