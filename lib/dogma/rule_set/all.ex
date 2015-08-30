defmodule Dogma.RuleSet.All do
  @moduledoc """
  The module which defines all the rules to run in Dogma.

  Rules to be run are returned by `list/0`
  """

  def list do
    [
      {BarePipeChainStart},
      {ComparisonToBoolean},
      {DebuggerStatement},
      {FinalNewline},
      {FunctionArity, max: 4},
      {FunctionName},
      {HardTabs},
      {LineLength, max_length: 80},
      {LiteralInCondition},
      {ModuleAttributeName},
      {ModuleDoc},
      {ModuleName},
      {NegatedIfUnless},
      {PredicateName},
      {QuotesInString},
      {Semicolon},
      {TrailingBlankLines},
      {TrailingWhitespace},
      {UnlessElse},
      {VariableName},
      {WindowsLineEndings},
      {LiteralInInterpolation}
    ]
  end
end
