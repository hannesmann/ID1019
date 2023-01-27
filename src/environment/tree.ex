# Map implemented with tree
# Format: {key, value, left, right}
defmodule EnvTree do
  def new() do nil end

  def add(nil, key, value) do
    {key, value, nil, nil}
  end

  # Replace value
  def add({key, _, left, right}, key, value) do
    {key, value, left, right}
  end

  # If key is smaller than the current node, walk down left branch
  def add({k, v, left, right}, key, value) when key < k do
    {k, v, add(left, key, value), right}
  end

  # If key is larger than the current node, walk down right branch
  def add({k, v, left, right}, key, value) do
    {k, v, left, add(right, key, value)}
  end

  # Same logic as add(), walk down tree until a match is found or node is nil
  def lookup(nil, _) do nil end
  def lookup({key, value, _, _}, key) do value end

  def lookup({k, _, left, _}, key) when key < k do
    lookup(left, key)
  end

  def lookup({_, _, _, right}, key) do
    lookup(right, key)
  end

  # Rest is the last right branch of the leftmost node
  def leftmost({key, value, nil, rest}) do {key, value, rest} end
  def leftmost({key, value, left, right}) do
    # Keep going left
    {k, v, rest} = leftmost(left)
    # Copy the leftmost node to a new node with the old left branch to the left and the right branch to the right
    {k, v, {key, value, rest, right}}
  end

  def remove(nil, _) do nil end

  # These paths will be hit if we only have a left or right branch, or no branches at all
  def remove({key, _, nil, right}, key) do right end
  def remove({key, _, left, nil}, key) do left end

  # If we have two branches we have to take that into consideration
  def remove({key, _, left, right}, key) do
    {k, v, rest} = leftmost(right)
    # Replace the current node with the leftmost (smallest) in the right branch
    {k, v, left, rest}
  end

  def remove({k, v, left, right}, key) when key < k do
    {k, v, remove(left, key), right}
  end

  def remove({k, v, left, right}, key) do
    {k, v, left, remove(right, key)}
  end
end
