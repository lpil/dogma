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
* [JSON](#json)
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


### JSON
`json`

A machine readable format in JSON.

The JSON structure is like the following example:

    {
      "metadata": {
        "dogma_version": "0.3.0",
        "elixir_version": "1.0.5",
        "erlang_version": "Erlang/OTP 10 [erts-7.0.3] [64-bit]",
        "system_architecture": "x86_64-apple-darwin14.5.0"
      },
      "files": [{
          "path": "lib/foo.ex",
          "errors": []
       }, {
          "path": "lib/bar.ex",
          "errors": [{
              "line": 1,
              "rule": "ModuleDoc",
              "message": "Module without @moduledoc detected",
              "fixed": false
           }, {
              "line": 14,
              "rule": "ComparisonToBoolean",
              "message": "Comparison to a boolean is useless",
              "fixed": true
           }
          ]
      }],
      "summary": {
        "error_count": 2,
        "inspected_file_count": 2
      }
    }


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



