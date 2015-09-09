defmodule Dogma.RuleSet.All do
  @moduledoc """
  The module which defines all the rules to run in Dogma.

  Rules to be run are returned by `list/0`
  """

  @behaviour Dogma.RuleSet

  def rules do
    [
      {BarePipeChainStart},
      {ComparisonToBoolean},
      {DebuggerStatement},
      {FinalCondition},
      {FinalNewline},
      {FunctionArity, max: 4},
      {FunctionName},
      {HardTabs},
      {LineLength, max_length: 80},
      {LiteralInCondition},
      {LiteralInInterpolation},
      {MatchInCondition},
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
    ]
  end
end
