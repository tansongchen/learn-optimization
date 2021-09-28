using JuMP
using Clp
using LinearAlgebra
using Plots

model = Model(Clp.Optimizer)

T = 100
d = 50
f = 1000
δ = 1e-3
m = 0
p = zeros(T)
q = zeros(T)

@variables(model, begin
        m >= 0
        p[1:T] >= 0
        q[1:T] >= 0
    end
)

@objective(model, Min, m)

@constraints(
	model,
	begin
        m .>= (p + q)
		sum(p) - sum(q) == 0
		sum((T - t) * (p[t] - q[t]) for t in 1:T) == d
        sum(p) + sum(q) <= f
        [t=1:T-1], -δ <= ((p[t] - q[t]) - (p[t + 1] - q[t + 1])) <= δ
    end
)

optimize!(model)

a = value.(p - q)
v = zeros(T + 1)
x = zeros(T + 1)
for t in 1:T
    v[t + 1] = v[t] + a[t]
    x[t + 1] = x[t] + v[t]
end

plot(1:T, a, label="a")
savefig("a.png")
plot(1:T+1, v, label="v")
savefig("v.png")
plot(1:T+1, x, label="x")
savefig("x.png")
