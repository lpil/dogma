defmodule Dogma.RuleSet.All do
  @moduledoc """
  The module which defines all the rules to run in Dogma.

  Rules to be run are returned by `list/0`
  """
  alias Dogma.Rule

  @behaviour Dogma.RuleSet

  def rules do
    [
      %Rule.CommentFormat{},
      %Rule.ComparisonToBoolean{},
      %Rule.DebuggerStatement{},
      %Rule.ExceptionName{},
      %Rule.FinalCondition{},
      %Rule.FinalNewline{},
      %Rule.FunctionArity{},
      %Rule.FunctionName{},
      %Rule.FunctionParentheses{},
      %Rule.HardTabs{},
      %Rule.InterpolationOnlyString{},
      %Rule.LineLength{},
      %Rule.LiteralInCondition{},
      %Rule.LiteralInInterpolation{},
      %Rule.MatchInCondition{},
      %Rule.ModuleAttributeName{},
      %Rule.ModuleDoc{},
      %Rule.ModuleName{},
      %Rule.MultipleBlankLines{},
      %Rule.NegatedAssert{},
      %Rule.NegatedIfUnless{},
      %Rule.PipelineStart{},
      %Rule.PredicateName{},
      %Rule.QuotesInString{},
      %Rule.Semicolon{},
      %Rule.SnakeCaseFilename{},
      %Rule.TakenName{},
      %Rule.TrailingBlankLines{},
      %Rule.TrailingWhitespace{},
      %Rule.UnlessElse{},
      %Rule.VariableName{},
      %Rule.WindowsLineEndings{},
    ]
  end
end
