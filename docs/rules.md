# Dogma Rules

These are the rules included in Dogma by default. Currently there are
21 of them.

## Contents

* [BarePipeChainStart](https://github.com/lpil/dogma/blob/master/docs/rules.md#barepipechainstart)
* [ComparisonToBoolean](https://github.com/lpil/dogma/blob/master/docs/rules.md#comparisontoboolean)
* [DebuggerStatement](https://github.com/lpil/dogma/blob/master/docs/rules.md#debuggerstatement)
* [FinalNewline](https://github.com/lpil/dogma/blob/master/docs/rules.md#finalnewline)
* [FunctionArity](https://github.com/lpil/dogma/blob/master/docs/rules.md#functionarity)
* [FunctionName](https://github.com/lpil/dogma/blob/master/docs/rules.md#functionname)
* [HardTabs](https://github.com/lpil/dogma/blob/master/docs/rules.md#hardtabs)
* [LineLength](https://github.com/lpil/dogma/blob/master/docs/rules.md#linelength)
* [LiteralInCondition](https://github.com/lpil/dogma/blob/master/docs/rules.md#literalincondition)
* [ModuleAttributeName](https://github.com/lpil/dogma/blob/master/docs/rules.md#moduleattributename)
* [ModuleDoc](https://github.com/lpil/dogma/blob/master/docs/rules.md#moduledoc)
* [ModuleName](https://github.com/lpil/dogma/blob/master/docs/rules.md#modulename)
* [NegatedIfUnless](https://github.com/lpil/dogma/blob/master/docs/rules.md#negatedifunless)
* [PredicateName](https://github.com/lpil/dogma/blob/master/docs/rules.md#predicatename)
* [QuotesInString](https://github.com/lpil/dogma/blob/master/docs/rules.md#quotesinstring)
* [Semicolon](https://github.com/lpil/dogma/blob/master/docs/rules.md#semicolon)
* [TrailingBlankLines](https://github.com/lpil/dogma/blob/master/docs/rules.md#trailingblanklines)
* [TrailingWhitespace](https://github.com/lpil/dogma/blob/master/docs/rules.md#trailingwhitespace)
* [UnlessElse](https://github.com/lpil/dogma/blob/master/docs/rules.md#unlesselse)
* [VariableName](https://github.com/lpil/dogma/blob/master/docs/rules.md#variablename)
* [WindowsLineEndings](https://github.com/lpil/dogma/blob/master/docs/rules.md#windowslineendings)


---

### BarePipeChainStart

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


### ComparisonToBoolean

A rule that disallows comparison to booleans.

For example, these are considered invalid:

    foo == true
    true != bar
    false === baz

This is because these expressions evalutate to `true` or `false`, so you
could get the same result by using either the variable directly, or negating
the variable.

Additionally, with a duck typed language such as Elixir, we should be more
interested in whether something is "truthy" or "falsey" than if they are
`true` or `false`.


### DebuggerStatement

A rule that disallows calls to IEx.pry, as while useful, we probably don't
want them committed.


### FinalNewline

A rule that disallows files that don't end with a final newline.


### FunctionArity

A rule that disallows functions with arity greater than 4 (configurable)


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


### HardTabs

Requires that all indentation is done using spaces rather than hard tabs.

So the following would be invalid:

def something do
	:body
end


### LineLength

A rule that disallows lines longer than 80 columns in length.


### LiteralInCondition

A rule that disallows useless conditional statements that contain a literal
in place of a variable or predicate function.


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


### NegatedIfUnless

A rule that disallows the use of an if or unless with a negated predicate,
When you do this, swap the `if` for an `unless`, or vice versa.

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


### PredicateName

A rule that disallows tautological predicate names, meaning those that start
with the prefix `has_` or the prefix `is_`.

Favour `valid?` over `is_valid?`, and `picture?` over `has_picture?`.


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

For example, this rule considers this variable assignment valid:

    my_mood = :happy

But it considers this one invalid:

    myMood = :sad


### WindowsLineEndings

A rule that disallows any lines terminated with `\r\n`, the line terminator
commonly used on the Windows operating system.

The preferred line terminator is is the Unix style `\n`.

If you are a Windows user you should be able to configure your editor to
write files with Unix style `\n` line terminators.


