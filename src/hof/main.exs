Code.require_file("recursion.ex")
Code.require_file("map.ex")
Code.require_file("reduce.ex")
Code.require_file("filter.ex")

test_numbers = [1, 2, 3, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048]
test_animals = [:dog, :cat, :cow, :horse]

IO.inspect(test_numbers, label: "test_numbers")
IO.inspect(test_animals, label: "test_animals")

IO.puts("")

IO.inspect(Recursion.double(test_numbers), label: "Recursion.double(test_numbers)")
IO.inspect(Recursion.five(test_numbers), label: "Recursion.five(test_numbers)")
IO.inspect(Recursion.animal(test_animals), label: "Recursion.animal(test_animals)")

IO.inspect(Recursion.sum(test_numbers), label: "Recursion.sum(test_numbers)")
IO.inspect(Recursion.odd(test_numbers), label: "Recursion.odd(test_numbers)")

IO.puts("")
IO.inspect(HofMap.apply_to_all(test_numbers, fn x -> x * 2 end), label: "HofReduce.apply_to_all(..., x -> x * 2)")
IO.inspect(HofMap.apply_to_all(test_numbers, fn x -> x + 5 end), label: "HofReduce.apply_to_all(..., x -> x + 5)")

IO.puts("")
IO.inspect(HofReduce.fold_right([1,2,3,4], 0, fn x, acc -> {x, acc} end), label: "HofReduce.fold_right(..., x, acc -> {x, acc})")
IO.inspect(HofReduce.fold_left([1,2,3,4], 0, fn x, acc -> {x, acc} end), label: "HofReduce.fold_left(..., x, acc -> {x, acc})")

IO.puts("")
IO.inspect(HofFilter.filter(test_numbers, fn x -> rem(x, 2) == 1 end), label: "HofReduce.filter(..., x -> rem(x, 2) == 1)")
