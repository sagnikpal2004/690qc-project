basis1 = SpinBasis(1//2)
ϕ⁺ = Ket(basis1 ⊗ basis1, [1.0+0.0im, 0.0+0.0im, 0.0+0.0im, 1.0+0.0im] / sqrt(2))
function werner_state(p::Float64)
    @assert 0 <= p <= 1 "p must be between 0 and 1."
    return p * dm(ϕ⁺) + 0.25(1 - p) * express(I ⊗ I)
end


function link_gen(network::Network, link_id::Int) 
    time_taken = network.param.link_generation_delay

    while true
        if rand() < network.param.entanglement_prob
            initialize!([
                network.factory_node.link_qubits[link_id], 
                network.end_nodes[link_id].qubit[1]
            ], werner_state(network.param.werner_prob))
            return time_taken
        end
        time_taken += network.param.link_generation_delay
    end
end