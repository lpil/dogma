Dogma
=====

<img src="https://raw.github.com/lpil/dogma/master/docs/for-shame.png" alt="FOR SHAME!" title="SHAME" align="right"/>

[![Build Status](https://travis-ci.org/lpil/dogma.svg?branch=master)](https://travis-ci.org/lpil/dogma)
[![Coverage](https://coveralls.io/repos/lpil/dogma/badge.svg)](https://coveralls.io/r/lpil/dogma)
[![Hex version](https://img.shields.io/hexpm/v/dogma.svg "Hex version")](https://hex.pm/packages/dogma)
[![Hex downloads](https://img.shields.io/hexpm/dt/dogma.svg "Hex downloads")](https://hex.pm/packages/dogma)
[![Inline docs](https://inch-ci.org/github/lpil/dogma.svg?branch=master&style=flat)](http://inch-ci.org/github/lpil/dogma)


Dogma is a principle or set of principles laid down by an authority as
**incontrovertibly true**.

It's also a code style linter for Elixir, powered by shame.

* [About](#about)
* [Usage](#usage)
* [Configuration][config-doc]
* [Rules][rules-doc]
* [Output formats][reporters-doc]

[config-doc]: https://github.com/lpil/dogma/blob/master/docs/configuration.md
[rules-doc]: https://github.com/lpil/dogma/blob/master/docs/rules.md
[reporters-doc]: https://github.com/lpil/dogma/blob/master/docs/reporters.md


## About

Dogma is a tool for enforcing a consistent Elixir code style within your
project, the idea being that if your code is easier to read, it should also be
easer to understand. It's highly configurable so you can adjust it to fit your
style guide, but comes with a sane set of defaults so for most people it
should just work out-of-the-box. I like to run Dogma on the CI server with
the test suite, and consider the build broken if Dogma reports a problem.

If you're interested in a tool more geared towards making style suggestions
rather than strictly enforcing your style guide, check out
[Credo](https://github.com/rrrene/credo).


## Usage

Add Dogma to your Mix dependencies

```elixir
# mix.exs
def deps do
  [
    {:dogma, "~> 0.0", only: :dev},
  ]
end
```

Fetch it:

```
mix deps.get
```

Run the mix task:

```
mix dogma
```

You'll get something like this:

```
Inspecting 27 files.

.....X..........X..........

27 files, 2 errors!

== lib/dogma/rules.ex ==
23: TrailingBlankLines: Blank lines detected at end of file

== test/dogma/formatter_test.exs ==
9: TrailingWhitespace: Trailing whitespace detected
```

How handy!


## Options
```--format``` can be one of ```flycheck```, ```json``` or ```simple``` (default)

```--stdin``` makes dogma read the source from stdin

## STDIN parsing
It is possible to use dogma to parse source direcly piped into it.
You can do this by cloning the repository, building and installing the archive like so :
```bash
git clone git@github.com:lpil/dogma.git
cd dogma
mix deps.get
mix archive.build
mix archive.install
```

You can now use dogma as a stand alone.  
To let dogma parse stdin use the ```--stdin``` flag. If there is no filename given it will use "stdin" as filename.

examples : 
```elixir
$> echo 'IO.puts( "hello world");' |  mix dogma --stdin                        
#> Inspecting 1 file.
#>
#> X
#>
#> 1 files, 1 error!
#>
#> == stdin ==
#> 1: ModuleDoc: Module BearCenter.Picture is missing a @moduledoc.
```
or 

```elixir
$> echo 'IO.puts( "hello world");' |  mix dogma --format=flycheck --stdin /my/path/example/hello_world.ex                        
#> /my/path/example/hello_world.ex:1:1: W: Expressions should not be terminated by semicolons.
```

The previous example is mostly for linters like Flycheck ((spac)emacs) which will flush a buffer via stdin, but requires a file mapping of the results.


## Contributor Information

### Test it

```sh
mix test       # Run tests once
mix test.watch # Run tests on file changes
mix dogma      # Dogfooding- run the linter!
```


### Read the developer docs

Check them out on [hexdocs][hexdocs-dogma], or generate them yourself:

[hexdocs-dogma]: http://hexdocs.pm/dogma/extra-api-reference.html

```sh
mix docs
```


# LICENCE

```
Dogma - A code style linter for Elixir, powered by shame.
Copyright © 2015 Louis Pilfold - MIT Licence

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
