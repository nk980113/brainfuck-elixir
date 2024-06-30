defmodule Loop do
  @moduledoc false

  defstruct list: []

  @type t :: %Loop{list: list(Lexer.cmd() | Loop)}
end
