# Environment backed by native Map
defmodule Environment do
  def new() do %{} end
  def new(bindings) when is_map(bindings) do bindings end

  def new(bindings) when is_list(bindings) do
    Enum.reduce(bindings, %{}, fn ({k, v}, map) -> Map.put(map, k, v) end)
  end

  def find(env, key) do env[key] end
end
