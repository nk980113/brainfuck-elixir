defmodule ParserTest do
  @moduledoc false
  use ExUnit.Case

  def to_parse_tree(string), do: Lexer.lex(string) |> Parser.parse()

  test "parse without loop" do
    assert to_parse_tree("++--><><BA, .") == {:ok, [:inc, :inc, :dec, :dec, :next, :prev, :next, :prev, :in, :out]}
  end

  test "parse with empty loop" do
    assert to_parse_tree("<[][]>") == {:ok, [:prev, %Loop{}, %Loop{}, :next]}
  end

  test "parse with 1 layer loop" do
    assert to_parse_tree("<[++--><><BA]>") == {:ok, [:prev, %Loop{list: [:inc, :inc, :dec, :dec, :next, :prev, :next, :prev]}, :next]}
  end

  test "parse with nested loop" do
    assert to_parse_tree("[<[Look, I'm nested!]>+<[Bruh, I'm nested too.[But I'm triple nested!]]>]")
      == {:ok, [%Loop{list: [:prev, %Loop{list: [:in]}, :next, :inc, :prev, %Loop{list: [:in, :out, %Loop{}]}, :next]}]}
  end

  test "bracket not closed" do
    assert to_parse_tree("[") == {:error, :bracket_not_closed}
  end

  test "nested bracket not closed" do
    assert to_parse_tree("[][[][") == {:error, :bracket_not_closed}
  end

  test "unexpected bracket" do
    assert to_parse_tree("]") == {:error, :unexpected_bracket}
  end

  test "nested unexpected bracket" do
    assert to_parse_tree("[+-+-+gfmkdf;km[]sdf[sdfkl;sdfkl;dfs[]mklsdfmk]]]") == {:error, :unexpected_bracket}
  end
end
