Code.require_file("huffman.ex")

defmodule Tests do
  def sample() do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end
end

freq = Huffman.freq(Tests.sample())
IO.inspect(freq, label: "freq")

tree = Huffman.tree(Tests.sample())
IO.inspect(tree, label: "tree")

encode_table = Huffman.encode_table(tree)
IO.inspect(encode_table, label: "encode_table")

encoded = Huffman.encode(Tests.text(), encode_table)
IO.inspect(encoded, label: "Tests.text() encoded")

decode_table = Huffman.decode_table(tree)
decoded = Huffman.decode(encoded, decode_table)
IO.inspect(decoded, label: "Tests.text() decoded")
