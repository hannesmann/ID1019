defmodule Simulator do
  def dart(r) do
    # Much faster than Enum.random
    x = :rand.uniform(r)
    y = :rand.uniform(r)

    r ** 2 > x ** 2 + y ** 2
  end

  def round(0, _, a) do a end
  def round(k, r, a) do
    # If we hit the target
    case dart(r) do
      true -> round(k - 1, r, a + 1)
      false -> round(k - 1, r, a)
    end
  end

  def rounds(k, j, r) do
    rounds(k, j, 0, r, 0)
  end

  def rounds(0, _, t, _, a) do 4 * a/t end

  # k = rounds left
  # j = darts each round
  # t = total thrown darts
  # r = radius of circle
  # a = total hit darts
  def rounds(k, j, t, r, a) do
    a = round(j, r, a)
    t = t + j
    # Multiply by 4 because we're only checking one arch
    pi = 4 * a/t

    cr = round(t/j)
    if rem(cr, 100) == 0 do
      :io.format("round ~p - pi: ~.12f abs error: ~.12f\n", [cr, pi, abs(pi - :math.pi())])
    end

    rounds(k - 1, j, t, r, a)
  end

  # Throws double darts every round starting at 1
  def rounds_doubling(k, r) do
    rounds_doubling(k, 1, r, 0)
  end

  def rounds_doubling(0, t, _, a) do 4 * a/t end

  # k = rounds left
  # t = total thrown darts
  # r = radius of circle
  # a = total hit darts
  def rounds_doubling(k, t, r, a) do
    a = round(t, r, a)
    t = t * 2
    # Multiply by 4 because we're only checking one arch
    pi = 4 * a/t

    cr = round(:math.log2(t))
    :io.format("round (doubling) ~p - pi: ~.12f abs error: ~.12f\n", [cr, pi, abs(pi - :math.pi())])

    rounds_doubling(k - 1, t, r, a)
  end
end
