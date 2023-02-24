Code.require_file("day16.ex")

valves = Day16.parse(Day16.sample())
#valves = Day16.parse(File.stream!("day16.csv"))

current = List.first(valves)
steps = []
exclude = Day16.exclude_default(valves)

# Repeat steps
steps = Enum.reduce(0..30, {current, [], MapSet.new()}, fn m, {current, steps, exclude} ->
  {{type, valve}, new_exclude, release} = Day16.best_move(current, m, exclude)

  if type == :move do
    current = valve
  end

  steps = steps ++ [{type, valve}]
  exclude = new_exclude

  {current, steps, exclude}
end)

IO.inspect(steps)
