# Implements map(list, f(elem)) with recursion
# Note: Module cannot be called "Map"
defmodule HofMap do
  def apply_to_all([], _) do [] end
  def apply_to_all([head | tail], f) do
    [f.(head) | apply_to_all(tail, f)]
  end
end
