defmodule Train do
  def take([], _) do [] end
  def take(_, 0) do [] end
  def take([head | tail], n) do
    [head | take(tail, n - 1)]
  end

  def drop([], _) do [] end
  def drop(list, 0) do list end
  def drop([_ | tail], n) do
    drop(tail, n - 1)
  end

  def append([], list) do
    list
  end

  def append([head | tail], rest) do
    [head | append(tail, rest)]
  end

  # Note: Could be implemented by matching is_number(position(train, y))
  def member([], _) do false end
  def member([y | _], y) do true end
  def member([_ | tail], y) do
    member(tail, y)
  end

  def position([], _) do :nomatch end
  def position([y | _], y) do 1 end
  def position([_ | tail], y) do
    case position(tail, y) do
      num when is_number(num) -> 1 + num
      err -> err
    end
  end

  def split([], _) do {[], []} end
  def split([y | tail], y) do {[], tail} end
  def split([head | tail], y) do
    {b, a} = split(tail, y)
    {[head | b], a}
  end


  def main([], n) do {n, [], []} end
  def main(remain, 0) do {0, remain, []} end
  def main([head | tail], n) do
    # Keep taking from tail
    {k, remain, take} = main(tail, n)

    # Can't take more
    if k == 0 do
      {k, [head | remain], take}
    else
      {k - 1, remain, [head | take]}
    end
  end

end
