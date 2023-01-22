defmodule Derivative do
  @type literal() :: { :num, number() } | { :var, atom() }

  @type expr() ::
    # a + b
    { :add, expr(), expr() } |
    # a * b
    { :mul, expr(), expr() } |
    # a / b
    { :div, expr(), expr() } |
    # a ^ n
    { :pow, expr(), { :num, number() } } |
    # ln(a)
    { :ln, literal() } |
    # sin(a)
    { :sin, literal() } |
    # cos(a)
    { :cos, literal() } |
    literal()

  defmodule DerivRules do
    def deriv({ :num, _ }, _) do { :num, 0 } end

    # The variable in the expression is the same variable as v
    # d/dv v = 1
    def deriv({ :var, v }, v) do { :num, 1 } end
    # The variable in the expression is an unrelated constant
    # d/dv c = 0
    def deriv({ :var, _ }, _) do { :num, 0 } end

    def deriv({ :add, e1, e2 }, v) do
      { :add, deriv(e1, v), deriv(e2, v) }
    end

    # Product rule
    def deriv({ :mul, e1, e2 }, v) do
      { :add, { :mul, deriv(e1, v), e2 }, { :mul, e1, deriv(e2, v) } }
    end

    # Quotient rule
    def deriv({ :div, e1, e2 }, v) do
      { :div, { :add, { :mul, deriv(e1, v), e2 }, { :mul, { :mul, e1, deriv(e2, v) }, { :num, -1 } } }, { :pow, e2, { :num, 2 } } }
    end

    # Power rule
    def deriv({ :pow, e, { :num, n } }, _) do
      { :mul, { :num, n }, { :pow, e, { :num, n - 1 } } }
    end

    def deriv({ :ln, e }, _) do
      { :div, { :num, 1 }, e }
    end

    def deriv({ :sin, e }, _) do
      { :cos, e }
    end

    def deriv({ :cos, e }, _) do
      { :mul, { :sin, e }, { :num, -1 } }
    end
  end

  defmodule SimplifyRules do
    # Constant folding
    def simplify_expr({ :add, { :num, a }, { :num, b } }) do { :num, a + b } end
    def simplify_expr({ :mul, { :num, a }, { :num, b } }) do { :num, a * b } end
    def simplify_expr({ :div, { :num, a }, { :num, b } }) do { :num, a / b } end
    def simplify_expr({ :pow, { :num, a }, { :num, b } }) do { :num, a ** b } end

    # Constant folding inside parentheses
    def simplify_expr({ :add, { :num, a }, { :add, { :num, b }, c } }) do simplify({ :add, { :num, a + b }, simplify_expr(c) }) end
    def simplify_expr({ :add, { :add, { :num, b }, c }, { :num, a } }) do simplify({ :add, { :num, a + b }, simplify_expr(c) }) end
    def simplify_expr({ :add, { :num, a }, { :add, c, { :num, b } } }) do simplify({ :add, { :num, a + b }, simplify_expr(c) }) end
    def simplify_expr({ :add, { :add, c, { :num, b } }, { :num, a } }) do simplify({ :add, { :num, a + b }, simplify_expr(c) }) end

    def simplify_expr({ :mul, { :num, a }, { :mul, { :num, b }, c } }) do simplify({ :mul, { :num, a * b }, simplify_expr(c) }) end
    def simplify_expr({ :mul, { :mul, { :num, b }, c }, { :num, a } }) do simplify({ :mul, { :num, a * b }, simplify_expr(c) }) end
    def simplify_expr({ :mul, { :num, a }, { :mul, c, { :num, b } } }) do simplify({ :mul, { :num, a * b }, simplify_expr(c) }) end
    def simplify_expr({ :mul, { :mul, c, { :num, b } }, { :num, a } }) do simplify({ :mul, { :num, a * b }, simplify_expr(c) }) end

    # Statements with no effects
    def simplify_expr({ :add, a, { :num, 0 } }) do simplify_expr(a) end
    def simplify_expr({ :add, { :num, 0 }, b }) do simplify_expr(b) end

    def simplify_expr({ :mul, _, { :num, 0 } }) do { :num, 0 } end
    def simplify_expr({ :mul, { :num, 0 }, _ }) do { :num, 0 } end

    def simplify_expr({ :mul, a, { :num, 1 } }) do simplify_expr(a) end
    def simplify_expr({ :mul, { :num, 1 }, a }) do simplify_expr(a) end

    def simplify_expr({ :div, a, { :num, 1 } }) do simplify_expr(a) end

    def simplify_expr({ :pow, a, { :num, 1 } }) do simplify_expr(a) end
    def simplify_expr({ :pow, _, { :num, 0 } }) do { :num, 1 } end
    def simplify_expr({ :pow, { :num, 0 }, _ }) do { :num, 0 } end

    # x*x
    def simplify_expr({ :mul, a, a }) do simplify({ :pow, simplify_expr(a), 2 }) end

    # Default/exit case
    def simplify_expr(a) do a end

    def simplify({ type, subexpr1, subexpr2 }) do
      simplify_expr({ type, simplify(subexpr1), simplify(subexpr2) })
    end

    def simplify(a) do a end
  end

  defmodule PrintRules do
    def print_two(e1, e2, symbol) do
      print_expr(e1)
      IO.write("#{symbol}")
      print_expr(e2)
    end

    def print_fun(e, name) do
      IO.write("#{name}(")
      print_expr(e)
      IO.write(")")
    end

    def print_expr({ :add, e1, e2 }) do print_two(e1, e2, "+") end
    def print_expr({ :mul, e1, e2 }) do print_two(e1, e2, "*") end
    def print_expr({ :div, e1, e2 }) do print_two(e1, e2, "/") end
    # Special case for sqrt(x)
    def print_expr({ :pow, e, { :num, 0.5 } }) do print_fun(e, "sqrt") end
    def print_expr({ :pow, e1, e2 }) do print_two(e1, e2, "^") end

    def print_expr({ :ln, e }) do print_fun(e, "ln") end
    def print_expr({ :sin, e }) do print_fun(e, "sin") end
    def print_expr({ :cos, e }) do print_fun(e, "cos") end

    def print_expr({ _, a }) do IO.write("#{a}") end

    def print_simple(expr) do print_expr(SimplifyRules.simplify(expr)) end
  end

  def solve_expr(expr) do
    IO.write("Expression: ")
    PrintRules.print_simple(expr)
    IO.puts("")

    IO.write("Derivative: ")
    PrintRules.print_simple(DerivRules.deriv(expr, :x))
    IO.puts("")
  end
end

Derivative.solve_expr({ :mul, { :num, 2 }, { :pow, {:var, :x}, {:num, 3 } } })
Derivative.solve_expr({ :sin, { :var, :x } })
# From example
Derivative.solve_expr({:add, {:mul, {:num, 4}, {:pow, {:var, :x}, {:num, 2}}}, {:add, {:mul, {:num, 3}, {:var, :x}}, {:num, 42}}})
Derivative.solve_expr({ :pow, { :var, :x }, { :num, 0.5 } })
