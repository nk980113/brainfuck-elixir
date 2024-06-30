defmodule LexerTest do
  @moduledoc false
  use ExUnit.Case

  test "lex" do
    assert Lexer.lex("Hello, world! [OS: But I don't wanna say hello world, I just wanna type some random thing like ++--><><BA.]") == [:in, :loopstart, :in, :inc, :inc, :dec, :dec, :next, :prev, :next, :prev, :out, :loopend]
  end
end
