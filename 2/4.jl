using JuMP
using Clp
using LinearAlgebra
using Plots

n = 100
grid = range(-1, 1, length=n)
f = ℯ.^grid
coeff = zeros(n, 5)
for degree in 0:4
    coeff[:, degree + 1] = grid .^ degree
end
errors = zeros(5)
polynomials = zeros(5, 5)
taylors = [1 0 0 0 0; 1 1 0 0 0; 1 1 1/2 0 0; 1 1 1/2 1/6 0; 1 1 1/2 1/6 1/24]

for d in 0:4

    model = Model(Clp.Optimizer)

    @variables(model, begin
        m >= 0
        a[1:5]
    end
    )

    @objective(model, Min, m)

    @constraints(model, begin
        [i=d+2:5], a[i] == 0
        m .>= f - coeff * a
        m .>= coeff * a - f
    end
    )

    optimize!(model)
    errors[d + 1] = objective_value(model)
    polynomials[d + 1, :] = value.(a)
end

plot(grid, f, label="e^x")
for d in 0:4
    plot!(grid, coeff * (polynomials[d + 1, :]), label="cheb $d")
end
savefig("polynomial.png")

plot(0:4, errors)
savefig("error.png")

for d in 0:4
    plot(grid, f, label="e^x")
    plot!(grid, coeff * polynomials[d + 1, :], label="cheb $d")
    plot!(grid, coeff * taylors[d + 1, :], label="tayl $d")
    savefig("compare-$d.png")
end
