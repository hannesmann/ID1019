# Evaluates simple math expressions
defmodule MathEvaluator do
  @type literal() ::
    { :num, number() } |
    { :q, number(), number() } |
    { :var, atom() }

  @type expr() ::
    {:add, expr(), expr()} |
    {:sub, expr(), expr()} |
    {:mul, expr(), expr()} |
    {:div, expr(), expr()} |
    literal()

  # The final result should always be in the form {:q, a, b}
  def reduce({:q, a, b}) do
    gcd = Integer.gcd(a, b)
    reduced = {:q, Kernel.div(a, gcd), Kernel.div(b, gcd)}

    case reduced do
      {_, n, 1} -> {:num, n}
      _ -> reduced
    end
  end

  def eval({:q, a, b}, _) do {:q, a, b} end
  def eval({:num, n}, _) do {:q, n, 1} end

  def eval({:var, k}, env) do
    eval(Environment.find(env, k), env)
  end

  def eval({:add, {:q, a, b}, {:q, c, d}}, _) do
    {:q, a*d + c*b, b*d}
  end

  def eval({:add, a, b}, env) do
    eval({:add, eval(a, env), eval(b, env)}, env)
  end

  def eval({:sub, {:q, a, b}, {:q, c, d}}, env) do
    eval({:add, {:q, a, b}, {:q, -c, d}}, env)
  end

  def eval({:sub, a, b}, env) do
    eval({:sub, eval(a, env), eval(b, env)}, env)
  end

  def eval({:mul, {:q, a, b}, {:q, c, d}}, _) do
    {:q, a*c, b*d}
  end

  def eval({:mul, a, b}, env) do
    eval({:mul, eval(a, env), eval(b, env)}, env)
  end

  def eval({:div, {:q, a, b}, {:q, c, d}}, env) do
    eval({:mul, {:q, a, b}, {:q, d, c}}, env)
  end

  def eval({:div, a, b}, env) do
    eval({:div, eval(a, env), eval(b, env)}, env)
  end

  # Evaluate expression and reduce/simplify final result
  def eval_and_reduce(expr, env) do
    evaluated = eval(expr, env)
    reduce(evaluated)
  end
end
