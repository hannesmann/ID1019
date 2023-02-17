Code.require_file("filesystem.ex")

root = {
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

Filesystem.print(root)

IO.puts("")
IO.puts("Directories with total size <= 100000 bytes:")

dirs = Filesystem.dirs_less_than_100000(root)
Enum.map(dirs, fn {name, _} -> IO.puts("'#{name}'") end)

IO.puts("")
IO.puts("Sum of directories: #{Enum.reduce(dirs, 0, fn e, acc -> acc + Filesystem.size(e) end)} bytes")
