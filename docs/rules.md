# Dogma Rules

These are the rules included in Dogma by default. Currently there are
28 of them.

## Contents

* [ComparisonToBoolean](#comparisontoboolean)
* [DebuggerStatement](#debuggerstatement)
* [ExceptionName](#exceptionname)
* [FinalCondition](#finalcondition)
* [FinalNewline](#finalnewline)
* [FunctionArity](#functionarity)
* [FunctionName](#functionname)
* [FunctionParentheses](#functionparentheses)
* [HardTabs](#hardtabs)
* [InterpolationOnlyString](#interpolationonlystring)
* [LineLength](#linelength)
* [LiteralInCondition](#literalincondition)
* [LiteralInInterpolation](#literalininterpolation)
* [MatchInCondition](#matchincondition)
* [ModuleAttributeName](#moduleattributename)
* [ModuleDoc](#moduledoc)
* [ModuleName](#modulename)
* [NegatedAssert](#negatedassert)
* [NegatedIfUnless](#negatedifunless)
* [PipelineStart](#pipelinestart)
* [PredicateName](#predicatename)
* [QuotesInString](#quotesinstring)
* [Semicolon](#semicolon)
* [TrailingBlankLines](#trailingblanklines)
* [TrailingWhitespace](#trailingwhitespace)
* [UnlessElse](#unlesselse)
* [VariableName](#variablename)
* [WindowsLineEndings](#windowslineendings)


---

### ComparisonToBoolean

A rule that disallows comparison to booleans.

For example, these are considered invalid:

    foo == true
    true != bar
    false === baz

This is because these expressions evaluate to `true` or `false`, so you
could get the same result by using either the variable directly, or negating
the variable.

Additionally, with a duck typed language such as Elixir, we should be more
interested in whether something is "truthy" or "falsey" than if they are
`true` or `false`.


### DebuggerStatement

A rule that disallows calls to `IEx.pry`.

This is because we don't want debugger breakpoints accidentally being
committed into our codebase.


### ExceptionName

A Rule that checks that exception names end with a trailing Error.

For example, prefer this:

    defmodule BadHTTPCodeError do
      defexception [:message]
    end

Not one of these:

    defmodule BadHTTPCode do
      defexception [:message]
    end

    defmodule BadHTTPCodeException do
      defexception [:message]
    end


### FinalCondition

A rule that checks that the last condition of a `cond` statement is `true`.

For example, prefer this:

    cond do
      1 + 2 == 5 ->
        "Nope"
      1 + 3 == 5 ->
        "Uh, uh"
      true ->
        "OK"
    end

Not this:

    cond do
      1 + 2 == 5 ->
        "Nope"
      1 + 3 == 5 ->
        "Nada"
      _ ->
        "OK"
    end

This rule will only catch those `cond` statements where the last condition
is a literal or a `_`. Complex expressions and function calls will not
generate an error.

For example, neither of the following will generate an error:

    cond do
      some_predicate? -> "Nope"
      var == :atom    -> "Yep"
    end

    cond do
      var == :atom    -> "Nope"
      some_predicate? -> "Yep"
    end

An atom may also be used as a catch-all expression in a `cond`, since it
evaluates to a truthy value. Suggested atoms are `:else` or `:otherwise`.

To allow one of these instead of `true`, pass it to the rule as a
`:catch_all` option.

If you would like to enforce the use of `_` as your catch-all condition, pass
the atom `:_` into the `:catch_all` option.

    cond do
      _ -> "Yep"
    end

    cond do
      :_ -> "Yep"
    end


### FinalNewline

A rule that disallows files that don't end with a final newline.


### FunctionArity

A rule that disallows functions and macros with arity greater than 4, meaning
a function may not take more than 4 arguments.

By default this function is considered invalid by this rule:

    def transform(a, b, c, d, e) do
      # Do something
    end

The maximum allowed arity for this rule can be configured with the `max`
option in your mix config.


### FunctionName

A rule that disallows function names not in `snake_case`.

`snake_case` is when only lowercase letters are used, and words are separated
with underscores, rather than spaces.

For example, this rule considers these function definition valid:

    def my_mood do
      :happy
    end

    defp my_belly do
      :full
    end

But it considers these invalid:

    def myMood do
      :sad
    end

    defp myBelly do
      :empty
    end


### FunctionParentheses

A rule that ensures function declarations use parentheses if and only if
they have arguments.

For example, this rule considers these function declarations valid:

    def foo do
      :bar
    end

    defp baz(a, b) do
      :fudd
    end

But it considers these invalid:

    def foo() do
      :bar
    end

    defp baz a, b do
      :fudd
    end


### HardTabs

Requires that all indentation is done using spaces rather than hard tabs.

So the following would be invalid:

    def something do
    \t:body # this line starts with a tab, not spaces
    end


### InterpolationOnlyString

A rule that disallows strings which are entirely the result of an
interpolation.

Good:

      output = inspect(self)

Bad:

      output = "#{inspect self}"


### LineLength

A rule that disallows lines longer than X characters in length (defaults to
80).

This rule can be configured with the `max_length` option, which allows you to
specify your own line max character count.


### LiteralInCondition

A rule that disallows useless conditional statements that contain a literal
in place of a variable or predicate function.

This is because a conditional construct with a literal predicate will always
result in the same behaviour at run time, meaning it can be replaced with
either the body of the construct, or deleted entirely.

This is considered invalid:

    if "something" do
      my_function(bar)
    end


### LiteralInInterpolation

A rule that disallows useless string interpolations
that contain a literal value instead of a variable or function.
Examples:

    "Hello #{:jose}"
    "The are #{4} cats."
    "Don't #{~s(interpolate)} literals"


### MatchInCondition

Disallows use of the match operator in the conditional constructs `if` and
`unless`. This is because it is often intended to be `==` instead, but was
mistyped. Also, since a failed match raises a MatchError, the conditional
construct is largely redundant.

The following would be invalid:

    if {x, y} = z do
      something
    end


### ModuleAttributeName

A rule that disallows module attribute names not in snake_case


### ModuleDoc

A rule which states that all modules must have documentation in the form of a
`@moduledoc` attribute.

This rule does run check interpreted Elixir files, i.e. those with the file
extension `.exs`.

This would be valid according to this rule:

    defmodule MyModule do
      @moduledoc """
      This module is valid as it has a moduledoc!
      Ideally the documentation would be more useful though...
      """
    end

This would not be valid:

    defmodule MyModule do
    end

If you do not want to document a module, explicitly do so by setting the
attribute to `false`.

    defmodule MyModule do
      @moduledoc false
    end


### ModuleName

A rule that disallows module names not in PascalCase.

For example, this is considered valid:

    defmodule HelloWorld do
    end

While this is considered invalid:

    defmodule Hello_World do
    end


### NegatedAssert

A rule that disallows the use of an assert or refute with a negated
argument. If you do this, swap the `assert` for an `refute`, or vice versa.

These are considered valid:

    assert foo
    refute bar

These are considered invalid:

    assert ! foo
    refute ! bar
    assert not foo
    refute not bar


### NegatedIfUnless

A rule that disallows the use of an if or unless with a negated predicate.
If you do this, swap the `if` for an `unless`, or vice versa.

These are considered valid:

    if happy? do
      party()
    end
    unless sad? do
      jump_up()
    end

These are considered invalid:

    if !happy? do
      stay_in_bed()
    end
    unless not sad? do
      mope_about()
    end


### PipelineStart

A rule that enforces that function chains always begin with a bare value,
rather than a function call with arguments.

For example, this is considered valid:

    "Hello World"
    |> String.split("")
    |> Enum.reverse
    |> Enum.join

While this is not:

    String.split("Hello World", "")
    |> Enum.reverse
    |> Enum.join


### PredicateName

A rule that disallows tautological predicate names, meaning those that start
with the prefix `has_` or the prefix `is_`.

Favour these:

    def valid?(x) do
    end

    def picture?(x) do
    end

Over these:

    def is_valid?(x) do
    end

    def has_picture?(x) do
    end


### QuotesInString

A rule that disallows strings containing the double quote character (`"`).

Use s_sigil or S_sigil instead or string literals in these situation.

    # Bad
    "\""

    # Good
    ~s(")


### Semicolon

A rule that disallows semicolons to terminate or separate statements.

For example, these are considered invalid:

    foo = "bar";
    bar = "baz"; fizz = :buzz

This is because Elixir does not require semicolons to terminate expressions,
and breaking up multiple expressions on different lines improves readability.


### TrailingBlankLines

A rule that disallows trailing blank lines as the end of a source file.


### TrailingWhitespace

A rule that disallows trailing whitespace at the end of a line.


### UnlessElse

A rule that disallows the use of an `else` block with the `unless` macro.

For example, the rule considers these valid:

    unless something do
      :ok
    end

    if something do
      :one
    else
      :two
    end

But it considers this one invalid as it is an `unless` with an `else`:

    unless something do
      :one
    else
      :two
    end

The solution is to swap the order of the blocks, and change the `unless` to
an `if`, so the previous invalid example would become this:

    if something do
      :two
    else
      :one
    end


### VariableName

A rule that disallows variable names not in `snake_case`.

`snake_case` is when only lowercase letters are used, and words are separated
with underscores, rather than spaces.

Good:

    my_mood = :happy
    [number_of_cats] = [3]
    {function_name, _, other_stuff} = node

Bad:

    myMood = :sad
    [numberOfCats] = [3]
    {functionName, meta, otherStuff} = node


### WindowsLineEndings

A rule that disallows any lines terminated with `\r\n`, the line terminator
commonly used on the Windows operating system.

The preferred line terminator is is the Unix style `\n`.

If you are a Windows user you should be able to configure your editor to
write files with Unix style `\n` line terminators.


