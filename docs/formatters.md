# Dogma Formatters

You can pass a format to the mix task using the `--format` flag.

```
> mix dogma --format=flycheck

lib/dogma/rules.ex:23:1: W: Blank lines detected at end of file
test/dogma/formatter_test.exs:9:1: W: Trailing whitespace detected
```

The default formatter is [Simple](#simple).

## Contents

* [Flycheck](#flycheck)
* [Null](#null)
* [Simple](#simple)


---

### Flycheck
`flycheck`

A machine-readable format suitable for integration with tools like
[Flycheck](https://github.com/flycheck/flycheck) or
[Syntastic](https://github.com/scrooloose/syntastic).

    /project/lib/test.ex:1:1: W: Module with out a @moduledoc detected
    /project/lib/test.ex:14:1: W: Comparison to a boolean is pointless


### Null
`null`

A formatter that prints nothing. Ever.


### Simple
`simple`

A formatter that prints a dot per file, followed by details at the end.

    Inspecting 27 files.

    .....X..........X..........

    27 files, 2 errors!

    == lib/dogma/rules.ex ==
    23: TrailingBlankLines: Blank lines detected at end of file

    == test/dogma/formatter_test.exs ==
    9: TrailingWhitespace: Trailing whitespace detected [33]



