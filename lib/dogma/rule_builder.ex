defmodule Dogma.MissingRuleDocError do
  defexception [:message]
end

defmodule Dogma.RuleBuilder do
  @moduledoc """
  The provider of the `defrule/3` macro through which we define rules.

      use Dogma.RuleBuilder

      defrule MyRule, [some_option: 2] do
        def test(rule, script) do
          # check the script...
        end
      end

  This expands into a module declaring a struct respresenting this rule
  and its options, as well as an implementation of the Dogma.Rule protocol
  for this struct.

  The body of this macro must define the `test/2`, which returns a list
  of any errors found.

  `Dogma.Error` and `Dogma.Script` are aliased to `Error` and `Script`
  inside the body of the macro.
  """

  defmacro __using__(_) do
    quote do
      require Dogma.RuleBuilder
      import Dogma.RuleBuilder, only: [defrule: 3, defrule: 2]
    end
  end

  defmacro defrule(name, [do: module_ast]) do
    quote do
      defrule unquote(name), [], do: unquote(module_ast)
    end
  end

  defmacro defrule(name, opts, [do: module_ast]) when is_list(opts) do
    opts = [{:enabled, true} | opts]
    quote do
      defmodule unquote(name) do
        alias Dogma.Error
        alias Dogma.Script

        defstruct unquote(opts)
        unquote(module_ast)

        if @moduledoc == nil do
          raise Dogma.MissingRuleDocError, message: "Rule missing @moduledoc"
        end
      end

      defimpl Dogma.Rule, for: unquote(name) do
        defdelegate test(rule, script), to: unquote(name)
      end
    end
  end
end
