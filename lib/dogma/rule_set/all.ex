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
      %Rule.LineLength{},
      %Rule.FinalNewline{},
      %Rule.FunctionArity{},
      %Rule.FunctionName{},
      %Rule.FunctionParentheses{},
    ]
    %{
      HardTabs                => [],
      InterpolationOnlyString => [],
      LiteralInCondition      => [],
      LiteralInInterpolation  => [],
      MatchInCondition        => [],
      ModuleAttributeName     => [],
      ModuleDoc               => [],
      ModuleName              => [],
      MultipleBlankLines      => [max_lines: 2],
      NegatedAssert           => [],
      NegatedIfUnless         => [],
      PipelineStart           => [],
      PredicateName           => [],
      QuotesInString          => [],
      Semicolon               => [],
      TrailingBlankLines      => [],
      TrailingWhitespace      => [],
      UnlessElse              => [],
      VariableName            => [],
      WindowsLineEndings      => [],
    }
  end
end
