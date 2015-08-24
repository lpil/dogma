ExUnit.start(formatters: [ShouldI.CLIFormatter])

defmodule DogmaTest.Helper do
  defmacro __using__(_) do
    quote do
      use ShouldI
      import DogmaTest.Matchers
    end
  end

  def pending do
    [:yellow, "P"]
    |> IO.ANSI.format
    |> IO.write
  end
end

defmodule DogmaTest.Matchers do

  import ExUnit.Assertions
  import ShouldI.Matcher

  defmatcher should_register_no_errors do
    quote do
      assert [] == var!(context).errors
    end
  end


  defmatcher should_register_errors(errors) do
    quote do
      assert unquote(errors) == var!(context).errors
    end
  end
end
