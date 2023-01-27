Code.require_file("list.ex")
Code.require_file("tree.ex")

defmodule Benchmark do
  # i = number of elements at start
  # n = number of extra elements
  def bench_list(i, n) do
    seq = Enum.map(1..i, fn _ -> :rand.uniform(i) end)
    list = Enum.reduce(seq, EnvList.new(), fn e, list -> EnvList.add(list, e, 0) end)
    seq = Enum.map(1..n, fn _ -> :rand.uniform(i) end)

    {addt, _} = :timer.tc(fn -> Enum.each(seq, fn e -> EnvList.add(list, e, 0) end) end)
    {lookupt, _} = :timer.tc(fn -> Enum.each(seq, fn e -> EnvList.lookup(list, e) end) end)
    {removet, _} = :timer.tc(fn -> Enum.each(seq, fn e -> EnvList.remove(list, e) end) end)

    {addt, lookupt, removet}
  end

  def bench_tree(i, n) do
    seq = Enum.map(1..i, fn _ -> :rand.uniform(i) end)
    list = Enum.reduce(seq, EnvTree.new(), fn e, list -> EnvTree.add(list, e, 0) end)
    seq = Enum.map(1..n, fn _ -> :rand.uniform(i) end)

    {addt, _} = :timer.tc(fn -> Enum.each(seq, fn e -> EnvTree.add(list, e, 0) end) end)
    {lookupt, _} = :timer.tc(fn -> Enum.each(seq, fn e -> EnvTree.lookup(list, e) end) end)
    {removet, _} = :timer.tc(fn -> Enum.each(seq, fn e -> EnvTree.remove(list, e) end) end)

    {addt, lookupt, removet}
  end

  def bench_map(i, n) do
    seq = Enum.map(1..i, fn _ -> :rand.uniform(i) end)
    list = Enum.reduce(seq, Map.new(), fn e, list -> Map.put(list, e, 0) end)
    seq = Enum.map(1..n, fn _ -> :rand.uniform(i) end)

    {addt, _} = :timer.tc(fn -> Enum.each(seq, fn e -> Map.put(list, e, 0) end) end)
    {lookupt, _} = :timer.tc(fn -> Enum.each(seq, fn e -> Map.get(list, e) end) end)
    {removet, _} = :timer.tc(fn -> Enum.each(seq, fn e -> Map.delete(list, e) end) end)

    {addt, lookupt, removet}
  end
end

n_str = List.first(System.argv())

if !n_str do
  IO.puts("Specify the initial size of the map")
else
  {n, _} = Integer.parse(n_str)
  ls = [16, 32, 64, 128, 256, 512, 1024, 2*1024, 4*1024, 8*1024]

  IO.puts("Testing EnvList...")
  :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])

  Enum.each(ls, fn i ->
    {tla, tll, tlr} = Benchmark.bench_list(i, n)
    :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
  end)

  IO.puts("Testing EnvTree...")
  :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])

  Enum.each(ls, fn i ->
    {tla, tll, tlr} = Benchmark.bench_tree(i, n)
    :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
  end)

  IO.puts("Testing Elixir Map...")
  :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])

  Enum.each(ls, fn i ->
    {tla, tll, tlr} = Benchmark.bench_map(i, n)
    :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
  end)
end
