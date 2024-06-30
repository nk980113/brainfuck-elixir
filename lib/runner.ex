defmodule Runner do
  @moduledoc false

  @cell_mod 30_000
  @int_mod 256

  @spec run(list(Lexer.cmd() | Loop.t())) :: nil
  def run(tree) do
    execute(tree, 0, Tuple.duplicate(0, @cell_mod))
    nil
  end

  @spec execute(list(Lexer.cmd() | Loop.t()), integer(), tuple()) :: {integer(), tuple()}
  defp execute([head | tail], ptr, cells) do
    {new_ptr, new_cells} = case head do
      %Loop{list: content} -> execute_loop(content, ptr, cells)
      cmd -> execute_single(cmd, ptr, cells)
    end
    execute(tail, new_ptr, new_cells)
  end

  defp execute([], ptr, cells), do: {ptr, cells}

  @spec execute_single(Lexer.cmd(), integer(), tuple()) :: {integer(), tuple()}
  defp execute_single(cmd, ptr, cells) do
    case cmd do
      :inc -> {ptr, put_elem(cells, ptr, elem(cells, ptr) + 1 |> rem(@int_mod))}
      :dec -> {ptr, put_elem(cells, ptr, elem(cells, ptr) - 1 + @int_mod |> rem(@int_mod))}
      :next -> {rem(ptr + 1, @cell_mod), cells}
      :prev -> {rem(ptr - 1 + @cell_mod, @cell_mod), cells}
      :in -> {ptr, put_elem(cells, ptr,
        case IO.getn("") |> IO.iodata_to_binary() do
          <<c>> -> c
          _ -> 0
        end)}
      :out ->
        IO.write([elem(cells, ptr)])
        {ptr, cells}
    end
  end

  @spec execute_loop(list(Lexer.cmd() | Loop.t()), integer(), tuple()) :: {integer(), tuple()}
  defp execute_loop(content, ptr, cells) do
    if elem(cells, ptr) != 0 do
      {new_ptr, new_cells} = execute(content, ptr, cells)
      execute_loop(content, new_ptr, new_cells)
    else
      {ptr, cells}
    end
  end
end
