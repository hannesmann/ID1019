Code.require_file("train.ex")
Code.require_file("moves.ex")
Code.require_file("shunt.ex")

test_train = [:b, :c, :a, :d]

IO.inspect(test_train, label: "test_train")
IO.inspect(Train.take(test_train, 2), label: "Train.take(test_train, 2)")
IO.inspect(Train.drop(test_train, 2), label: "Train.drop(test_train, 2)")
IO.inspect(Train.append(test_train, [:e, :f]), label: "Train.append(test_train, [:e, :f])")
IO.inspect(Train.member(test_train, :b), label: "Train.member(test_train, :b)")
IO.inspect(Train.member(test_train, :x), label: "Train.member(test_train, :x)")
IO.inspect(Train.position(test_train, :b), label: "Train.position(test_train, :b)")
IO.inspect(Train.position(test_train, :a), label: "Train.position(test_train, :a)")
IO.inspect(Train.position(test_train, :x), label: "Train.position(test_train, :x)")
IO.inspect(Train.split(test_train, :b), label: "Train.split(test_train, :b)")
IO.inspect(Train.split(test_train, :a), label: "Train.split(test_train, :a)")
IO.inspect(Train.split(test_train, :z), label: "Train.split(test_train, :z)")
IO.inspect(Train.main([:a, :b, :c, :d], 3), label: "Train.main([:a, :b, :c, :d], 3)")
IO.inspect(Train.main([:a, :b, :c, :d], 5), label: "Train.main([:a, :b, :c, :d], 5)")

IO.puts("")

IO.inspect(Moves.sequence([{:one, 1}, {:two, 1}, {:one, -1}, {:two, -1}], {[:a,:b], [], []}), label: "Moves.sequence(...)")

IO.puts("")

IO.inspect(Shunt.find([:a, :b], [:b, :a]), label: "Shunt.find(...)")
IO.inspect(Shunt.few([:c,:a,:b], [:c,:b,:a]), label: "Shunt.few(...)")

IO.puts("")

IO.inspect(Shunt.compress([{:two,-1},{:one,1},{:one,-1},{:two,1}]), label: "Shunt.compress([{:two,-1},{:one,1},{:one,-1},{:two,1}])")
