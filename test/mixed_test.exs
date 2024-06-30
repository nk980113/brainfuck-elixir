defmodule MixedTest do
  @moduledoc false

  use ExUnit.Case
  import ExUnit.CaptureIO

  test "Hello, world!" do
    assert capture_io(fn -> Main.run_file("./testcases/hello.bf") end) == "Hello, World!"
  end
end
