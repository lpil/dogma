defmodule Dogma.Rules.Sets.All do
  alias Dogma.Rules

  @moduledoc """
  The module which defines all the rules to run in Dogma.

  Rules to be run are returned by `list/0`
  """

  def list do
    [
      {DebuggerStatement},
      {FinalNewline},
      {LineLength, max_length: 80},
      {LiteralInCondition},
      {ModuleDoc},
      {ModuleName},
      {NegatedIfUnless},
      {QuotesInString},
      {TrailingBlankLines},
      {TrailingWhitespace},
      {UnlessElse},
      {WindowsLineEndings}
    ]
  end
end
