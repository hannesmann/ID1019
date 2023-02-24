Code.require_file("chopstick.ex")

defmodule Philosopher do
  def rand_sleep(0) do :ok end
  def rand_sleep(t) do
    # Average: :rand.uniform(t)
    :timer.sleep(:rand.uniform(t) * 2)
  end

  def start(hunger, left, right, name, ctrl, strength) do
    spawn_link(fn -> dreaming({hunger, left, right, name, ctrl, strength}) end)
  end

  def dreaming({hunger, left, right, name, ctrl, strength}) do
    # Sleep for a while...
    rand_sleep(200)
    # Wake up!
    waiting_left({hunger, left, right, name, ctrl, strength})
  end

  def waiting_left({hunger, left, right, name, ctrl, strength}) do
    rand_sleep(3000)
    case Chopstick.request(left, 1000) do
      :ok ->
        IO.puts("[#{name}] received left chopstick")
        waiting_right({hunger, left, right, name, ctrl, strength})
      :no ->
        if strength - 1 == 0 do
          IO.puts("[#{name}] died waiting for left chopstick")
          send(ctrl, :done)
        else
          waiting_left({hunger, left, right, name, ctrl, strength - 1})
        end
    end
  end
  def waiting_right({hunger, left, right, name, ctrl, strength}) do
    rand_sleep(3000)
    case Chopstick.request(right, 1000) do
      :ok ->
        IO.puts("[#{name}] received right chopstick")
        eating({hunger, left, right, name, ctrl, strength})
      :no ->
        if strength - 1 == 0 do
          IO.puts("[#{name}] died waiting for right chopstick")
          send(ctrl, :done)
        else
          waiting_right({hunger, left, right, name, ctrl, strength - 1})
        end
    end
  end

  def eating({hunger, left, right, name, ctrl, strength}) do
    Enum.each(0..hunger, fn _ ->
      # Eating...
      rand_sleep(100)
    end)

    Chopstick.return(left)
    Chopstick.return(right)

    IO.puts("[#{name}] finished eating")
    send(ctrl, :done)

    dreaming({hunger, left, right, name, ctrl, strength})
  end
end
