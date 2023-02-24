Code.require_file("chopstick.ex")
Code.require_file("philosopher.ex")

defmodule Dinner do
  def start(chopsticks, philosophers), do: spawn(fn -> init(chopsticks, philosophers) end)

  def init(chopsticks, philosophers) do
    c = Enum.map(0..chopsticks, fn _ -> Chopstick.start() end)
    Enum.map(0..philosophers, fn n -> Philosopher.start(5, Enum.at(c, rem(n, chopsticks)), Enum.at(c, rem(n + 1, chopsticks)), n, self(), 5) end)
    wait(philosophers, c)
  end

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(c) -> Chopstick.terminate(c) end)
  end

  def wait(n, chopsticks) do
    receive do
      :done -> wait(n - 1, chopsticks)
      :abort -> Process.exit(self(), :kill)
    end
  end
end
