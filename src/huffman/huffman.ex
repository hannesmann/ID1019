defmodule Huffman do
  # Init stage
  def freq(sample) do
    freq(sample, %{})
  end

  # End stage
  def freq([], weights) do
    weights
  end

  # Search stage
  def freq([head | tail], weights) do
    current = Map.get(weights, head, 0)
    freq(tail, Map.put(weights, head, current + 1))
  end

  def build_huffman([{last, _}], []) do
    # We should only have one element left in the list
    last
  end

  def build_huffman([{c1, f1}, {c2, f2}], rest) do
    list = rest ++ [{{c1, c2}, f1 + f2}]
    # Apply sorting recursively
    sorted_list = Enum.sort_by(list, fn {_, v} -> v end)

    build_huffman(Enum.take(sorted_list, 2), Enum.drop(sorted_list, 2))
  end

  # The format of the tree is: {node|char, node|char}
  def huffman(weights) do
    # Start by converting the map to a format [{a, 1}, {b, 2}, etc...]
    list = Map.to_list(weights)
    # Let lowest frequency weights be ordered first
    sorted_list = Enum.sort_by(list, fn {_, v} -> v end)

    build_huffman(Enum.take(sorted_list, 2), Enum.drop(sorted_list, 2))
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def encode_table({l, r}) do
    left = Enum.map(encode_table(l), fn {c, p} -> {c, [0] ++ p} end)
    right = Enum.map(encode_table(r), fn {c, p} -> {c, [1] ++ p} end)

    Map.new(left ++ right)
  end

  def encode_table(c) do
    [{c, []}]
  end

  # The decode table is the opposite of the encode table: Instead of k => v it goes v => k
  def decode_table({l, r}) do
    left = Enum.map(decode_table(l), fn {p, c} -> {[0] ++ p, c} end)
    right = Enum.map(decode_table(r), fn {p, c} -> {[1] ++ p, c} end)

    # Don't convert this one to a Map, get() does not work on arrays
    left ++ right
  end

  def decode_table(c) do
    [{[], c}]
  end

  def encode([], _) do [] end

  def encode([last], table) do
    Map.get(table, last)
  end

  def encode([head | tail], table) do
    Map.get(table, head) ++ encode(tail, table)
  end

  def decode_char(seq, n, max, table) do
    {code, rest} = Enum.split(seq, n)

    if n > max do
      {:error, rest}
    else
      case Enum.find(table, :error, fn {k, _} -> k == code end) do
        :error -> decode_char(seq, n + 1, max, table)
        {_, v} -> {v, rest}
      end
    end
  end

  def decode([], _, _) do [] end
  def decode(seq, table, max) do
    {char, rest} = decode_char(seq, 1, max, table)
    [char | decode(rest, table, max)]
   end

  def decode([], _) do [] end
  def decode(seq, table) do
    {max_key_length, _} = Enum.max_by(table, fn {k, _} -> length(k) end)
    decode(seq, table, max_key_length)
  end
end
