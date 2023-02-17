# Implements filter(list, f(elem)) with recursion
defmodule HofFilter do
  def filter([], _) do [] end
  def filter([head | tail], f) do
    if f.(head) do [head | filter(tail, f)] else filter(tail, f) end
  end
end
