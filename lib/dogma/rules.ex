defmodule Dogma.Rules do
  alias Dogma.Rules
  
  @moduledoc """
  The module which defines all the rules to run in Dogma.
  
  Rules to be run are returned by `list/0`
  """
  
  def list do
    [
      {Rules.DebuggerStatement},
      {Rules.FinalNewline},
      {Rules.LineLength, max_length: 80},
      {Rules.LiteralInCondition},
      {Rules.ModuleName},
      {Rules.NegatedIfUnless},
      {Rules.QuotesInString},
      {Rules.TrailingBlankLines},
      {Rules.TrailingWhitespace},
      {Rules.UnlessElse},
      {Rules.WindowsLineEndings}
    ]
  end
end
