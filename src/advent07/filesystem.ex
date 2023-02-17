defmodule Filesystem do
  @type file() :: { String.t(), integer() }
  @type directory() :: { String.t(), list(entry()) }
  @type entry() :: file() | directory()

  # Get size of directory or file
  def size({_, []}) do 0 end
  def size({name, [head | tail]}) do size(head) + size({name, tail}) end
  def size({_, size}) do size end

  # Walk tree and print directory structure
  def print(entry, indent \\ "")
  def print({name, entries}, indent) when is_list(entries) do
    # This has to be special-cased because Advent of Code prints the root directory as "/"
    name = case name do
      "" -> "/"
      _ -> name
    end

    IO.puts("#{indent}- #{name} (dir, size=#{size({name, entries})})")
    Enum.map(entries, fn e -> print(e, indent <> "  ") end)
  end
  def print({name, size}, indent) do
    IO.puts("#{indent}- #{name} (file, size=#{size})")
  end

  # Find by path
  def find(entry, path) when is_binary(path) do
    find(entry, String.split(path, "/"))
  end

  # Find by path split into list
  def find(entry, [head | tail]) do
    case entry do
      # If we have files and subdirectories to search
      {_, entries} when is_list(entries) and length(tail) > 0 -> Enum.find_value(entries, fn e -> find(e, tail) end)
      # If we are at the last part of the path and it matches our current "root" entry
      {root, _} when root == head and length(tail) == 0 -> entry
      _ -> nil
    end
  end

  # Walk tree and find all dirs with total size of <= 100000 bytes
  def dirs_less_than_100000(entry, acc \\ [])
  def dirs_less_than_100000({name, entries}, acc) when is_list(entries) do
    this_size = size({name, entries})

    if this_size <= 100000 do
      Enum.reduce(entries, acc ++ [{name, entries}], &dirs_less_than_100000/2)
    else
      Enum.reduce(entries, acc, &dirs_less_than_100000/2)
    end
  end
  def dirs_less_than_100000(_, acc) do acc end

  # Walk tree and find all dirs
  def dirs(entry, acc \\ [])
  def dirs({name, entries}, acc) when is_list(entries) do
    Enum.reduce(entries, acc ++ [{name, entries}], &dirs/2)
  end
  def dirs(_, acc) do acc end
end
