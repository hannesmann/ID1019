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

IO.puts("Directories with total size <= 100000:")
Enum.map(Filesystem.dirs_less_than_100000(root), fn {name, _} -> IO.puts("'#{name}'") end)
