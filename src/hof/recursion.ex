# Recursive examples from assignment
defmodule Recursion do
  def double_five_animal([], _) do [] end
  def double_five_animal([head | tail], op) do
    case {op, head} do
      {:double, _} -> [head * 2 | double_five_animal(tail, op)]
      {:five, _} -> [head + 5 | double_five_animal(tail, op)]
      {:animal, :dog} -> [:fido | double_five_animal(tail, op)]
      _ -> [head | double_five_animal(tail, op)]
    end
  end

  def double(list) do double_five_animal(list, :double) end
  def five(list) do double_five_animal(list, :five) end
  def animal(list) do double_five_animal(list, :animal) end

  def sum([]) do 0 end
  def sum([head | tail]) do head + sum(tail) end

  def odd([]) do [] end
  def odd([head | tail]) do
    case head do
      head when rem(head, 2) == 1 -> [head | odd(tail)]
      _ -> odd(tail)
    end
  end
end
