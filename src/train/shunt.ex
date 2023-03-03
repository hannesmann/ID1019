Code.require_file("train.ex")
Code.require_file("moves.ex")

defmodule Shunt do
  def find([], []) do [] end

  def find(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    moves = [{:one, length(ts) + 1}, {:two, length(hs)}, {:one, -length(ts) - 1}, {:two, -length(hs)}]
    Train.append(moves, find(Train.append(hs, ts), ys))
  end

  def few([], []) do [] end
  def few(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)

    if length(hs) == 0 do
      Train.append([], few(Train.append(hs, ts), ys))
    else
      moves = [{:one, length(ts) + 1}, {:two, length(hs)}, {:one, -length(ts) - 1}, {:two, -length(hs)}]
      Train.append(moves, few(Train.append(hs, ts), ys))
    end
  end

  def rules([]) do [] end
  def rules([head | tail]) do
    case head do
      {_, 0} -> rules(tail)
      {:one, n} ->
        case tail do
          [{:one, m} | rest] -> [{:one, n + m} | rules(rest)]
          _ -> [head | rules(tail)]
        end
      {:two, n} ->
        case tail do
          [{:two, m} | rest] -> [{:two, n + m} | rules(rest)]
          _ -> [head | rules(tail)]
        end
    end
  end

  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
      ms
    else
      compress(ns)
    end
  end
end
