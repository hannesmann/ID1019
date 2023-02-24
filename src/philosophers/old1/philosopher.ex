Code.require_file("chopstick.ex")

defmodule Philosopher do
  def rand_sleep(0) do :ok end
  def rand_sleep(t) do
    # Average: :rand.uniform(t)
    :timer.sleep(:rand.uniform(t) * 2)
  end

  def start(hunger, left, right, name, ctrl) do
    spawn_link(fn -> dreaming({hunger, left, right, name, ctrl}) end)
  end

  def dreaming({hunger, left, right, name, ctrl}) do
    # Sleep for a while...
    rand_sleep(200)
    # Wake up!
    waiting({hunger, left, right, name, ctrl})
  end

  def waiting({hunger, left, right, name, ctrl}) do
    Chopstick.request(left)
    IO.puts("[#{name}] received left chopstick")
    # rand_sleep(1000)
    # Causes deadlock
    Chopstick.request(right)
    IO.puts("[#{name}] received right chopstick")

    eating({hunger, left, right, name, ctrl})
  end

  def eating({hunger, left, right, name, ctrl}) do
    Enum.each(0..hunger, fn _ ->
      # Eating...
      rand_sleep(100)
    end)

    Chopstick.return(left)
    Chopstick.return(right)

    IO.puts("[#{name}] finished eating")
    send(ctrl, :done)

    dreaming({hunger, left, right, name, ctrl})
  end
end
