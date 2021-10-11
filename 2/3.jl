using JLD2
@load "2/data.jld2" c d A B b D f G g

using JuMP
using Clp
using LinearAlgebra

p1 = 25
p2 = 100
p3 = 200
n = 50
m = 100

# Primal

primal = Model(Clp.Optimizer)

@variables(primal, begin
        x[1:n]
        y[1:m]
    end
)

@objective(primal, Min, c'x + d'y)

@constraints(
	primal,
	begin
        A * x + B * y .== b
		D * x .<= f
        G * y .<= g
    end
)

optimize!(primal)

x̂ = value.(x)
ŷ = value.(y)

# Dual

dual = Model(Clp.Optimizer)

@variables(dual, begin
        p[1:p1]
        q[1:p2] <= 0
        r[1:p3] <= 0
    end
)

@objective(dual, Max, p'b + q'f + r'g)

@constraints(
	dual,
	begin
        p'A + q'D .== c'
        p'B + r'G .== d'
    end
)

optimize!(dual)

println("primal: ", objective_value(primal))
println("dual: ", objective_value(dual))
@assert objective_value(primal) ≈ objective_value(dual)
