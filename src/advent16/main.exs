Code.require_file("day16.ex")

valves = Day16.parse(Day16.sample())
#valves = Day16.parse(File.stream!("day16.csv"))

current = :AA
steps = []

# Repeat steps
