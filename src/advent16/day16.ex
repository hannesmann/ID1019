defmodule Day16 do
  def sample() do
    ["Valve AA has flow rate=0; tunnels lead to valves DD, II, BB",
     "Valve BB has flow rate=13; tunnels lead to valves CC, AA",
     "Valve CC has flow rate=2; tunnels lead to valves DD, BB",
     "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE",
     "Valve EE has flow rate=3; tunnels lead to valves FF, DD",
     "Valve FF has flow rate=0; tunnels lead to valves EE, GG",
     "Valve GG has flow rate=0; tunnels lead to valves FF, HH",
     "Valve HH has flow rate=22; tunnel leads to valve GG",
     "Valve II has flow rate=0; tunnels lead to valves AA, JJ",
     "Valve JJ has flow rate=21; tunnel leads to valve II"]
  end

  ## Parser from course material
  def parse(input) do
    Enum.map(input, fn(row) ->
      [valve, rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_Valve, valve | _has_flow_rate ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      [_, _tunnels,_lead,_to,_valves| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, fn(valve) -> String.to_atom(String.trim(valve,",")) end)
      {valve, {rate, valves}}
    end)
  end

  # :move => move to next valve
  # :open => open current valve
  @type valve() :: {atom(), {integer(), list()}}
  @type step() :: { :move, valve() }, { :open, valve() }

  def total_valve_release({_, {flow, _}}, minute) do
    flow * (30 - minute)
  end

  def exclude_default(valves) do
    result = Enum.filter(valves, fn {_, {f, _}} -> f == 0 end)
    result = Enum.map(valves, fn {a, _} -> a end)

    MapSet.new(result)
  end

  @spec best_move(valve(), integer(), MapSet) :: {step(), list(atom()), integer()}
  def best_move({valve, {flow, neighbors}}, minute, exclude) do
    release = total_valve_release({valve, {flow, neighbors}}, minute)
    exclude = MapSet.put(exclude, valve)

    neighbors = Enum.filter(neighbors, fn {valve, _} -> !MapSet.member?(exclude, valve) end)
    neighbors = Enum.map(neighbors, fn e -> {e, best_move(e, minute - 1, exclude)} end)
    neighbors = Enum.sort_by(neighbors, fn {e, {move, exclude, release}} -> release end)

    {best_neighbor, {_, new_exclude, neighbor_release}} = List.first(neighbors, 1)

    if !best_neighbor or neighbor_release <= release do
      {{:open, {valve, {flow, neighbors}}}, exclude, release}
    else
      {{:move, best_neighbor}, new_exclude, neighbor_release}
    end
  end
end
