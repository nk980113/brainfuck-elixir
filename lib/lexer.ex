defmodule Lexer do
  @moduledoc false

  @charmap %{
    ?> => :next,
    ?< => :prev,
    ?+ => :inc,
    ?- => :dec,
    ?. => :out,
    ?, => :in,
    ?[ => :loopstart,
    ?] => :loopend,
  }

  @type cmd() :: :next | :prev | :inc | :dec | :out | :in
  @type group() :: :loopstart | :loopend

  @type token() :: cmd() | group()

  @spec lex(String.t()) :: list(token())
  def lex(input) do
    to_charlist(input)
      |> Enum.map(&(Map.get(@charmap, &1)))
      |> Enum.filter(&(!!&1))
  end
end
