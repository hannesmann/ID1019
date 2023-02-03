Code.require_file("environment.ex")
Code.require_file("evaluator.ex")

defmodule Test do
  def eval_and_print(expr, vars) do
    result = MathEvaluator.eval_and_reduce(expr, vars)

    case result do
      {:num, n} -> IO.puts("#{n}")
      {:q, a, b} -> IO.puts("#{a}/#{b}")
    end
  end
end

Test.eval_and_print({:div, {:mul, {:num, 5}, {:num, 2}}, {:num, 5645}}, Environment.new())
Test.eval_and_print({:mul, {:num, 5}, {:var, :x}}, Environment.new(%{:x => {:num, 10}}))
