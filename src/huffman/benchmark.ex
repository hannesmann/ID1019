Code.require_file("huffman.ex")

defmodule HuffmanBenchmark do
  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)

    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} -> list
      list -> list
    end
  end

  def run_for(_, 1, _, _, _) do
    IO.puts("Done")
  end

  def run_for(text, n, repeats, et, dt) do
    IO.puts("n=#{n}:")

    IO.write("  encode avg: ")
    {encode_time, encoded} = :timer.tc(fn -> Enum.map(1..repeats, fn _ -> Huffman.encode(Enum.take(text, n), et) end) end)
    encoded = List.first(encoded)
    IO.puts("#{encode_time / repeats} microseconds")

    IO.write("  decode avg: ")
    {decode_time, _} = :timer.tc(fn -> Enum.map(1..repeats, fn _ -> Huffman.decode(encoded, dt) end) end)
    IO.puts("#{decode_time / repeats} microseconds")
    IO.puts("")

    run_for(text, Integer.floor_div(n, 2), repeats, et, dt)
  end

  def run() do
    IO.puts("Encoding and decoding kallocain.txt (5 repeats for every benchmark)")
    IO.puts("")

    kallocain = read("kallocain.txt")

    tree = Huffman.tree(kallocain)
    encode_table = Huffman.encode_table(tree)
    decode_table = Huffman.decode_table(tree)

    run_for(kallocain, length(kallocain), 5, encode_table, decode_table)
  end
end
