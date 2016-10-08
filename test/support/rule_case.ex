defmodule RuleCase do
  @moduledoc """
  A test case macro that removes boilerplate when testing rules.

  It aliases `Dogma.Rule`, `Dogma.Script`, `Dogma.Error`, as well as the
  rule being tested (assuming it us in the `Dogma.Rule` namespace.

      defmodule Dogma.Rule.LineLengthTest do
        use RuleCase, for: LineLength
      end
  """

  defmacro __using__(for: {:__aliases__, _, [name]}) do
    full_name = Module.concat( Dogma.Rule, name )
    quote do
      use ExUnit.Case, async: true
      alias Dogma.Rule
      alias Dogma.Script
      alias Dogma.Error
      alias unquote(full_name)
      @rule %unquote(full_name){}
    end
  end
end
