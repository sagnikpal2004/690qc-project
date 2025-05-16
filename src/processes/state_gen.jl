include("../states/ghz.jl")

function state_gen(network::Network)
    initialize!([
        network.factory_node.memory_qubits[i] 
        for i in 1:network.param.num_end_nodes
    ], ghz_state(network.param.num_end_nodes))
end