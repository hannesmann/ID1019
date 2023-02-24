Code.require_file("dinner.ex")

Process.monitor(Dinner.start())

receive do
  {:DOWN, _, _, _, reason} -> IO.puts("Exited - Reason: #{reason}")
end
