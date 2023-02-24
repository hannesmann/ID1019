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
    rand_sleep(500)

    # Wake up!
    Chopstick.send_request(left)
    Chopstick.send_request(right)

    left_waiter = Chopstick.get_wait_function(left, 2500)
    right_waiter = Chopstick.get_wait_function(right, 2500)

    waiting({hunger, left, right, name, ctrl, strength, {left_waiter, right_waiter}})
  end

  def waiting({_, _, _, name, ctrl, 0, _}) do
    IO.puts("[#{name}] died waiting for chopstick")
    send(ctrl, :done)
  end

  def waiting({hunger, left, right, name, ctrl, strength, {left_waiter, right_waiter}}) do
    case {left_waiter.(), right_waiter.()} do
      {:ok, :ok} -> eating({hunger, left, right, name, ctrl, strength})
      {_, :ok} -> waiting({hunger, left, right, name, ctrl, strength - 1, {left_waiter, fn -> :ok end}})
      {:ok, _} -> waiting({hunger, left, right, name, ctrl, strength - 1, {fn -> :ok end, right_waiter}})
      _ -> waiting({hunger, left, right, name, ctrl, strength - 2, {left_waiter, right_waiter}})
    end
  end

  def eating({hunger, left, right, name, ctrl, strength}) do
    Enum.each(0..hunger, fn _ ->
      # Eating...
      rand_sleep(100)
    end)

    Chopstick.return(left)
    Chopstick.return(right)

    IO.puts("[done] #{name} finished eating")
    send(ctrl, :done)

    dreaming({hunger, left, right, name, ctrl, strength})
  end
end
