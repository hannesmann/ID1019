# Implements filter(list, f(elem)) with recursion
defmodule HofFilter do
  def filter([], _) do [] end
  def filter([head | tail], f) do
    # Ensure f.(head) is true or false
    [!!f.(head) | filter(tail, f)]
  end
end
