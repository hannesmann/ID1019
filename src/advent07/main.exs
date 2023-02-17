Code.require_file("filesystem.ex")
Code.require_file("parser.ex")

_test = {
  "", [
    {
      "a", [
        {
          "e", [
            {"i", 584}
          ],
        },
        {"f", 29116},
        {"g", 2557},
        {"h.lst", 62596}
      ]
    },
    {"b.txt", 14848514},
    {"c.dat", 8504156},
    {
      "d", [
        {"j", 4060174},
        {"d.log", 8033020},
        {"d.ext", 5626152},
        {"k", 7214296}
      ]
    }
  ]
}

#Filesystem.print(test)

root = FilesystemParser.parse(File.stream!("day07.txt"))
# Filesystem.print(root)

dirs = Filesystem.dirs_less_than_100000(root)
sum = Enum.reduce(dirs, 0, fn e, acc -> acc + Filesystem.size(e) end)

IO.puts("Sum of directories with total size <= 100000: #{sum}")
IO.puts("")

dirs = Filesystem.dirs(root)

root_size = Filesystem.size(root)
free_space = 70000000 - root_size
required_to_delete = 30000000 - free_space

IO.inspect(root_size, label: "root_size")
IO.inspect(free_space, label: "free_space")
IO.inspect(required_to_delete, label: "required_to_delete")

IO.puts("")

sorted_by_size = Enum.filter(dirs, fn e -> Filesystem.size(e) >= required_to_delete end)
sorted_by_size = Enum.sort_by(sorted_by_size, &Filesystem.size/1)
{to_delete, _} = List.first(sorted_by_size)

IO.puts("Directory to be deleted: #{to_delete}")
IO.puts("Size: #{Filesystem.size(List.first(sorted_by_size))}")
