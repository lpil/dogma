defmodule Dogma.RuleSet.All do
  @moduledoc """
  The module which defines all the rules to run in Dogma.

  Rules to be run are returned by `list/0`
  """

  @behaviour Dogma.RuleSet

  def rules do
    %{
      CommentFormat           => [],
      ComparisonToBoolean     => [],
      DebuggerStatement       => [],
      ExceptionName           => [],
      FinalCondition          => [],
      FinalNewline            => [],
      FunctionArity           => [max: 4],
      FunctionName            => [],
      FunctionParentheses     => [],
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
      # %Dogma.Rule.LineLength{},
    }
  end
end
