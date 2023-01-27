Code.require_file("list.ex")
Code.require_file("tree.ex")

# Simple test to see that structures match
numbers = Enum.map(1..5, fn _ -> Enum.random(1..5000) end)
mapone = Enum.reduce(numbers, EnvList.new(), fn(n, list) -> if !EnvList.lookup(list, n) do EnvList.add(list, n, 0) end end)
maptwo = Enum.reduce(numbers, EnvTree.new(), fn(n, list) -> if !EnvTree.lookup(list, n) do EnvTree.add(list, n, 0) end end)

IO.inspect(mapone)
IO.inspect(maptwo)

remove = Enum.random(numbers)
IO.puts "Trying to remove #{remove}"

mapone = EnvList.remove(mapone, remove)
maptwo = EnvTree.remove(maptwo, remove)

IO.inspect(mapone)
IO.inspect(maptwo)
