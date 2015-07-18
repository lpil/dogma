defmodule Dogma.Script.SkipperTest do
  use ShouldI

  alias Dogma.Script
  alias Dogma.Script.Skipper

  with "an exs file" do

    setup context do
      %{
        script: Script.parse( "1 + 1", "foo.exs" )
      }
    end

    should "be skipped if configured", context do
      skipped? = context.script |> Skipper.skip?(skip_exs_files: true)
      assert skipped? == true
    end

    should "not be skipped if the config flag isn't set", context do
      skipped? = context.script |> Skipper.skip?([something: "else"])
      assert skipped? == false
    end
  end

  with "an ex file" do

    setup context do
      %{
        script: Script.parse( "1 + 1", "foo.ex" )
      }
    end

    should "not be skipped if the config for exs files is set", context do
      skipped? = context.script |> Skipper.skip?(skip_exs_files: true)
      assert skipped? == false
    end
  end

end
