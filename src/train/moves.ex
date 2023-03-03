Code.require_file("train.ex")

defmodule Moves do
  # Perform move on state
  def single({:one, n}, {main, one, two}) when n >= 0 do
    # Move from main to one
    {_, remain, take} = Train.main(main, n)
    {remain, Train.append(one, take), two}
  end

  def single({:one, n}, {main, one, two}) when n < 0 do
    # Move from one to main
    {_, remain, take} = Train.main(one, -n)
    {Train.append(main, take), remain, two}
  end

  def single({:two, n}, {main, one, two}) when n >= 0 do
    # Move from main to two
    {_, remain, take} = Train.main(main, n)
    {remain, one, Train.append(two, take)}
  end

  def single({:two, n}, {main, one, two}) when n < 0 do
    # Move from two to main
    {_, remain, take} = Train.main(two, -n)
    {Train.append(main, take), one, remain}
  end

  def sequence([], state) do [state] end
  def sequence([head | tail], state) do
    [state | sequence(tail, single(head, state))]
  end
end
