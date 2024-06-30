defmodule Main do
  @moduledoc false

  def main([]) do
    IO.puts("Usage: brainfuck_elixir [file]")
  end

  def main(args) do
    hd(args) |> run_file()
  end

  def run_file(filename) do
    with {:ok, binary} <- File.read(filename),
      {:ok, tree} <- IO.chardata_to_string(binary) |> Lexer.lex() |> Parser.parse() do
        Runner.run(tree)
    else
      err ->
        case err do
          {:error, reason} -> reason
        end
          |> exit()
    end
  end
end
