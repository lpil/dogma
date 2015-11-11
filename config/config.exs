use Mix.Config

config :dogma,
  rule_set: Dogma.RuleSet.All,
  override: %{ MultipleBlankLines => [ max_lines: 2 ] }
