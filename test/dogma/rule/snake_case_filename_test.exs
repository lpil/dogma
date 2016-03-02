defmodule Dogma.Rule.SnakeCaseFilenameTest do
  use RuleCase, for: SnakeCaseFilename

  should "not generate errors for snake cased files" do
    result = Script.parse!("", "this_is_correct.ex")

    expected_error = []

    assert expected_error == Rule.test(@rule, result)
  end

  should "error when a file contains invalid characters" do
    result = Script.parse!("", "ThisIs-so.Wrong.ex")

    expected_error = [%Dogma.Error{
      line: 0,
      message: "Rename ThisIs-so.Wrong.ex to this_is_so_wrong.ex",
      rule: Dogma.Rule.SnakeCaseFilename
    }]

    assert expected_error == Rule.test(@rule, result)
  end
end
