defprotocol Dogma.Rule do
  @doc """
  A function that tests a script to see if it violates
  the rule, and returns a list of errors.

  The first argument is the struct that represents the rule and contains the
  configuration for the rule.

  The second argument is the script struct to be tested.
  """
  def test(rule, script)

  @callback test(%{}, %Dogma.Script{}) :: [%Dogma.Error{}]
end
