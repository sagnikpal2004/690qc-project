include("../states/werner.jl")

function link_gen(network::Network, link_id::Int) 
    time_taken = 2 * network.param.link_delay

    while true
        if rand() < network.param.entanglement_prob
            initialize!([
                network.factory_node.link_qubits[link_id], 
                network.end_nodes[link_id].qubit[1]
            ], werner_state(network.param.werner_prob))
            return time_taken
        end
        time_taken += 2 * network.param.link_delay
    end
end