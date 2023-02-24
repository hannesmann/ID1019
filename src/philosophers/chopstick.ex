defmodule Chopstick do
  def start() do
    spawn_link(fn -> available() end)
  end

  def available() do
    receive do
      {:request, from} ->
        send(from, {:received, self()})
        gone()
      :quit -> :ok
    end
  end

  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end

  def send_request(stick) do
    send(stick, {:request, self()})
  end

  def get_wait_function(stick, timeout) do
    fn ->
      receive do
        {:received, stick} -> :ok
      after timeout ->
        :no
      end
    end
  end

  def return(stick) do
    send(stick, :return)
    # No need to wait for message here since we know we are the owner
  end

  def terminate(stick) do
    send(stick, :quit)
  end
end
