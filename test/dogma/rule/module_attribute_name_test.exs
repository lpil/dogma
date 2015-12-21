defmodule Dogma.Rule.ModuleAttributeNameTest do
  use RuleCase, for: ModuleAttributeName

  should "not error with snake_case module attribute names" do
    script = """
    defmodule HelloWorld do
      @hello_world 1
      @hello 2
    end
    """ |> Script.parse!("")
    assert [] == Rule.test( @rule, script )
  end

  should "error for a camelCase module attribute name" do
    script = """
    defmodule SnakeCase do
      @helloWorld 1
      @hello_World 1
    end
    """ |> Script.parse!("")
    expected_errors = [
      %Error{
        rule:     ModuleAttributeName,
        message:  "Module attribute names should be in snake_case",
        line: 3,
      },
      %Error{
        rule:     ModuleAttributeName,
        message:  "Module attribute names should be in snake_case",
        line: 2,
      },
    ]
    assert expected_errors == Rule.test( @rule, script )
  end
end
