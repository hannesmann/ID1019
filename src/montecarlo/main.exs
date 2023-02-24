Code.require_file("simulator.ex")

# r is set to theoretically biggest radius on 32-bit computers
IO.puts("Simulator.rounds(1000, 1000, ...)")
Simulator.rounds(1000, 1000, trunc(:math.sqrt(134217728)))
IO.puts("")

IO.puts("Simulator.rounds_doubling(26, ...)")
Simulator.rounds_doubling(26, trunc(:math.sqrt(134217728)))
IO.puts("")

IO.puts("#{4 * Enum.reduce(0..1000, 0, fn(k,a) -> a + 1/(4*k + 1) - 1/(4*k + 3) end)}")
