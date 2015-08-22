# Dogma Rules

These are the rules included in Dogma by default.

## Contents

* [DebuggerStatement](https://github.com/lpil/dogma/blob/master/docs/rules.md#debuggerstatement)
* [FinalNewline](https://github.com/lpil/dogma/blob/master/docs/rules.md#finalnewline)
* [FunctionArity](https://github.com/lpil/dogma/blob/master/docs/rules.md#functionarity)
* [FunctionName](https://github.com/lpil/dogma/blob/master/docs/rules.md#functionname)
* [LineLength](https://github.com/lpil/dogma/blob/master/docs/rules.md#linelength)
* [LiteralInCondition](https://github.com/lpil/dogma/blob/master/docs/rules.md#literalincondition)
* [ModuleAttributeName](https://github.com/lpil/dogma/blob/master/docs/rules.md#moduleattributename)
* [ModuleDoc](https://github.com/lpil/dogma/blob/master/docs/rules.md#moduledoc)
* [ModuleName](https://github.com/lpil/dogma/blob/master/docs/rules.md#modulename)
* [NegatedIfUnless](https://github.com/lpil/dogma/blob/master/docs/rules.md#negatedifunless)
* [QuotesInString](https://github.com/lpil/dogma/blob/master/docs/rules.md#quotesinstring)
* [TrailingBlankLines](https://github.com/lpil/dogma/blob/master/docs/rules.md#trailingblanklines)
* [TrailingWhitespace](https://github.com/lpil/dogma/blob/master/docs/rules.md#trailingwhitespace)
* [UnlessElse](https://github.com/lpil/dogma/blob/master/docs/rules.md#unlesselse)
* [VariableName](https://github.com/lpil/dogma/blob/master/docs/rules.md#variablename)
* [WindowsLineEndings](https://github.com/lpil/dogma/blob/master/docs/rules.md#windowslineendings)


---

### DebuggerStatement

A rule that disallows calls to IEx.pry, as while useful, we probably don't
want them committed.


### FinalNewline

A rule that disallows files that don't end with a final newline.


### FunctionArity

A rule that disallows functions with arity greater than 4 (configurable)


### FunctionName

A rule that disallows function names not in snake_case


### LineLength

A rule that disallows lines longer than 80 columns in length.


### LiteralInCondition

A rule that disallows useless conditional statements that contain a literal
in place of a variable or predicate function.


### ModuleAttributeName

A rule that disallows module attribute names not in snake_case


### ModuleDoc

A rule that disallows the use of an if or unless with a negated predicate

Skips .exs files.


### ModuleName

A rule that disallows module names not in PascalCase


### NegatedIfUnless

A rule that disallows the use of an if or unless with a negated predicate


### QuotesInString

A rule that disallows strings containing double quotes.
Use s_sigil or S_sigil instead.


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


