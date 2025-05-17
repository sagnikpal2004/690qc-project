using CentralQNet


const T2 = 1.0 #sec
const num_end_nodes = 5
const L = 50 #km
const werner_prob = 0.9 

param = NetworkParam(
    T2 = T2,
    num_end_nodes = num_end_nodes,

    entanglement_prob = exp(-L/44)^2 / 2,
    werner_prob = werner_prob,
    link_delay = L / 2e5
)

const run_count = 10^6

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