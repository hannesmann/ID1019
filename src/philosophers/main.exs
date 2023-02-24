Code.require_file("dinner.ex")

Enum.map(1..10, fn n ->
  start = System.system_time(:millisecond)
  IO.puts("Spawning #{n * 10} philosophers")
  Process.monitor(Dinner.start(10, n * 10))

  receive do
    {:DOWN, _, _, _, reason} -> IO.puts("Exited - Reason: #{reason}, lasted for: #{System.system_time(:millisecond) - start} ms")
  end
end)
