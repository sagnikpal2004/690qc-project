using CentralQNet

const L = 50 #km
const c = 2e5 #km/s

param = NetworkParam(
    T2 = 1.0,
    num_end_nodes = 3,

    entanglement_prob = 0.9,
    werner_prob = 0.9,
    link_generation_delay = L / c
)

run_count = 10^6

success_count = 0
times = Float64[]
fidelities = Float64[]
for i in 1:run_count
    time, fidelity = run_sim(Network(param))

    if fidelity < 0.5
        continue
    end

    global success_count += 1
    push!(times, time)
    push!(fidelities, fidelity)
    println("Run $i: Time = $time, Fidelity = $fidelity")
end

using Statistics

average_time = mean(times)
std_dev_time = std(times, mean=average_time)

average_fidelity = mean(fidelities)
std_dev_fidelity = std(fidelities, mean=average_fidelity)

success_rate = success_count / run_count

println("Average Time: ", average_time)
println("Standard Deviation: ", std_dev_time)
println("Average Fidelity: ", average_fidelity)
println("Standard Deviation: ", std_dev_fidelity)
println("Success Rate: ", success_rate)