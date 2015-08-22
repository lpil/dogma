# Dogma Rules

These are the rules included in Dogma by default.

## DebuggerStatement

A rule that disallows calls to IEx.pry, as while useful, we probably don't
want them committed.


## FinalNewline

A rule that disallows files that don't end with a final newline.


## FunctionArity

A rule that disallows functions with arity greater than 4 (configurable)


## FunctionName

A rule that disallows function names not in snake_case


## LineLength

A rule that disallows lines longer than 80 columns in length.


## LiteralInCondition

A rule that disallows useless conditional statements that contain a literal
in place of a variable or predicate function.


## ModuleAttributeName

A rule that disallows module attribute names not in snake_case


## ModuleDoc

A rule that disallows the use of an if or unless with a negated predicate

Skips .exs files.


## ModuleName

A rule that disallows module names not in PascalCase


## NegatedIfUnless

A rule that disallows the use of an if or unless with a negated predicate


## QuotesInString

A rule that disallows strings containing double quotes.
Use s_sigil or S_sigil instead.


## TrailingBlankLines

A rule that disallows trailing blank lines as the end of a source file.


## TrailingWhitespace

A rule that disallows trailing whitespace at the end of a line.


## UnlessElse

A rule that disallows the use of an `else` block with the `unless` macro.


## VariableName

A rule that disallows variable names not in snake_case


## WindowsLineEndings

A rule that disallows any lines terminated with `\r\n`, the line terminator
commonly used on the Windows operating system.

The preferred line terminator is is the Unix style `\n`.

If you are a Windows user you should be able to configure your editor to
write files with Unix style `\n` line terminators.


