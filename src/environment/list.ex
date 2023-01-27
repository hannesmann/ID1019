# Map implemented with list
# Format: [{key, value}...]
defmodule EnvList do
  def new() do [] end

  def add(map, key, value) do
    map ++ [{key, value}]
  end

  def lookup(map, key) do
    Enum.find_value(map, fn {k, v} -> k == key and v end)
  end

  def remove(map, key) do
    Enum.filter(map, fn {k, _} -> k != key end)
  end
end
