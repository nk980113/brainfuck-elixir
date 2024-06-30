defmodule Parser do
  @moduledoc false

  @spec parse(list(Lexer.token())) :: {:ok, list(Lexer.cmd() | Loop.t())} | {:error, atom()}
  def parse([head | tail]) do
    case head do
      :loopstart ->
        with {:ok, loop, rest} <- parse_loop(tail),
          {:ok, acc} <- parse(rest) do
            {:ok, [loop | acc]}
        else
          err -> err
        end
      :loopend -> {:error, :unexpected_bracket}
      token ->
        case parse(tail) do
          {:ok, acc} -> {:ok, [token | acc]}
          err -> err
        end
    end
  end

  def parse([]) do
    {:ok, []}
  end

  @spec parse_loop(list(Lexer.token())) :: {:ok, Loop.t(), list(Lexer.token())} | {:error, atom()}
  defp parse_loop([head | tail]) do
    case head do
      :loopstart ->
        with {:ok, inner_loop, rest} <- parse_loop(tail),
          {:ok, %Loop{list: list}, acc} <- parse_loop(rest) do
            {:ok, %Loop{list: [inner_loop | list]}, acc}
        else
          err -> err
        end
      :loopend -> {:ok, %Loop{}, tail}
      token ->
        case parse_loop(tail) do
          {:ok, %Loop{list: list}, acc} -> {:ok, %Loop{list: [token | list]}, acc}
          err -> err
        end
    end
  end

  defp parse_loop([]) do
    {:error, :bracket_not_closed}
  end
end
