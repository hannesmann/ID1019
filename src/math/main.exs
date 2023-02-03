Code.require_file("environment.ex")
Code.require_file("evaluator.ex")

defmodule Test do
  def eval_and_print(expr, vars) do
    IO.inspect(expr)
    IO.inspect(vars)
    result = MathEvaluator.eval_and_reduce(expr, vars)

    case result do
      {:num, n} -> IO.puts("#{n}")
      {:q, a, b} -> IO.puts("#{a}/#{b}")
    end
  end
end

Test.eval_and_print({:div, {:mul, {:num, 5}, {:num, 2}}, {:num, 5645}}, Environment.new())
Test.eval_and_print({:mul, {:num, 5}, {:var, :x}}, Environment.new(%{:x => {:num, 10}}))
Test.eval_and_print({:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 1,2}}, Environment.new(%{:x => {:num, 80}}))
