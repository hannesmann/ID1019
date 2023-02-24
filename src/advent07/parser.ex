Code.require_file("filesystem.ex")

defmodule FilesystemParser do
  def adddir({name, entries}, [], dir) do
    {name, entries ++ [{dir, []}]}
  end
  def adddir({name, entries}, [head | tail], dir) do
    # {name, entries ++ [{file, size}]}
    {name, Enum.map(entries, fn {n, l} ->
      if head == n do
        adddir({n, l}, tail, dir)
      else
        {n, l}
      end
    end)}
  end

  def addfile({name, entries}, [], file, size) do
    {name, entries ++ [{file, size}]}
  end
  def addfile({name, entries}, [head | tail], file, size) do
    {name, Enum.map(entries, fn {n, l} ->
      if head == n do
        addfile({n, l}, tail, file, size)
      else
        {n, l}
      end
    end)}
  end

  def parse(input) do
    {tree, _} = Enum.reduce(input, {{"", []}, []}, fn row, {root, stack} ->
      if String.first(row) == "$" do
        cmd = String.split(String.trim(row), " ")

        case Enum.at(cmd, 1) do
          "cd" ->
            [_, _, extra] = String.split(String.trim(row), " ")

            case extra do
              "/" -> {root, []}
              ".." -> {root, Enum.drop(stack, -1)}
              _ -> {root, stack ++ [extra]}
            end
          _ -> {root, stack}
        end
      else
        [type, name] = String.split(String.trim(row), " ")

        if type == "dir" do
          {adddir(root, stack, name), stack}
        else
          {size, _} = Integer.parse(type)
          {addfile(root, stack, name, size), stack}
        end
      end
    end)

    tree
  end
end
