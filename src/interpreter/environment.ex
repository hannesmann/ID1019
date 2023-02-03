# Environment backed by native Map
defmodule Environment do
  def new() do %{} end
  def new(bindings) when is_map(bindings) do bindings end

  def new(bindings) when is_list(bindings) do
    Enum.reduce(bindings, %{}, fn ({k, v}, map) -> Map.put(map, k, v) end)
  end

  def add(env, id, structure) do Map.put(env, id, structure) end
  def find(env, id) do {id, env[id]} end
  def remove(env, id) do Map.delete(env, id) end
end
