defmodule TowerOfHanoi do
  def hanoi(0, _, _, _) do [] end

  def hanoi(n, from, aux, to) do
    hanoi(n - 1, from, to, aux) ++ [{:move, from, to}] ++ hanoi(n - 1, aux, from, to)
  end
end

case List.first(System.argv()) do
  nil -> IO.puts("Specify max bound for n")
  str -> case Integer.parse(str) do
    {max, _} -> Enum.map(0..max,
      fn n ->
        result = TowerOfHanoi.hanoi(n, :a, :b, :c)

        IO.puts("Towers of Hanoi n=#{n}")
        IO.inspect(result)
        IO.puts("moves=#{length(result)} (expected: 2^#{n} - 1 = #{2 ** n - 1})")
      end
    )
    :error -> IO.puts("Invalid argument")
  end
end
