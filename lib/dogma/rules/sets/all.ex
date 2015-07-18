defmodule Dogma.Rules.Sets.All do
  @moduledoc """
  The module which defines all the rules to run in Dogma.

  Rules to be run are returned by `list/0`
  """

  def list do
    [
      {DebuggerStatement},
      {FinalNewline},
      {FunctionArity, max: 4},
      {FunctionName},
      {LineLength, max_length: 80},
      {LiteralInCondition},
      {ModuleAttributeName},
      {ModuleDoc},
      {ModuleName},
      {NegatedIfUnless},
      {QuotesInString},
      {TrailingBlankLines},
      {TrailingWhitespace},
      {UnlessElse},
      {VariableName},
      {WindowsLineEndings}
    ]
  end
end
