using Pkg
Pkg.add("Distributions")
Pkg.add("Plots")
using Distributions
using Plots

days = 65

alive_plants = 1000

for i in 1:days 
    days = i    
    
    binom = Binomial(1, .999)

    live_dead = rand(binom, alive_plants)

    daily_dead = sum(live_dead[isequal.(live_dead, 0)])

    println("On day $days, $daily_dead plants died")

    alive_plants = alive_plants - daily_dead
end

alive_plants


alive_runs = Vector{Any}()

for j in 1:1000
    days = 65

    alive_plants = 1000

for i in 1:days 
    days = i
    
    binom = Binomial(1, .999)

    live_dead = rand(binom, alive_plants)

    daily_dead = sum(live_dead[isequal.(live_dead, 0)])

    alive_plants = alive_plants - daily_dead
end

push!(alive_runs, alive_plants)

end

histogram(alive_runs)