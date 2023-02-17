# Implements reduce(list, base, f(elem, acc)) with recursion
defmodule HofReduce do
  def fold_right([], base, _) do base end
  def fold_right([head | tail], base, f) do
    f.(head, fold_right(tail, base, f))
  end

  def fold_left([], base, _) do base end
  def fold_left([head | tail], base, f) do
    fold_left(tail, f.(head, base), f)
  end
end
