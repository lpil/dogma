defmodule Dogma.Util.CyclomaticComplexityTest do
  use DogmaTest.Helper

  alias Dogma.Util.CyclomaticComplexity

  defmacro complexity_of(do: code) do
    code |> CyclomaticComplexity.count
  end

  with "an empty AST" do
    should "be 1" do
      size = complexity_of do end
      assert 1 == size
    end
  end

  should "register if" do
    size = complexity_of do
      if foo do
        bar
      end
    end
    assert 2 == size
  end

  should "register unless" do
    size = complexity_of do
      unless foo do
        bar
      end
    end
    assert 2 == size
  end

  should "register case" do
    size = complexity_of do
      case foo do
        1 -> :one
        _ -> :not_one
      end
    end
    assert 2 == size
  end

  should "register cond" do
    size = complexity_of do
      cond do
        foo == 1   -> :one
        :otherwise -> :not_one
      end
    end
    assert 2 == size
  end

  should "register &&" do
    size = complexity_of do
      1 && 2
    end
    assert 2 == size
  end

  should "register and" do
    size = complexity_of do
      1 and 2
    end
    assert 2 == size
  end

  should "register ||" do
    size = complexity_of do
      1 || 2
    end
    assert 2 == size
  end

  should "register or" do
    size = complexity_of do
      1 or 2
    end
    assert 2 == size
  end
end
