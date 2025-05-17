module CentralQNet

using QuantumSavory
using QuantumOptics

struct FactoryNode 
    memory_qubits::Register
    link_qubits::Register
end
function FactoryNode(num_qubits::Int, T2::Float64 = 0.0)
    @assert num_qubits > 0 "Number of qubits must be positive."
    return FactoryNode(Register(num_qubits, T2Dephasing(T2)), Register(num_qubits, T2Dephasing(T2)))
end

struct EndNode
    qubit::Register
end
function EndNode(T2::Float64 = 0.0)
    reg = Register(1, T2Dephasing(T2))
    return EndNode(reg)
end

struct NetworkParam
    T2::Float64
    num_end_nodes::Int

    entanglement_prob::Float64
    werner_prob::Float64
    link_delay::Float64

    function NetworkParam(;
        T2::Float64 = 0.0,
        num_end_nodes::Int, 

        entanglement_prob::Float64 = 1.0,
        werner_prob::Float64 = 0.0,
        link_delay::Float64 = 0.0
    )
        @assert 0 <= T2                     "T2 must be non-negative."
        @assert 0 <  num_end_nodes          "Number of end nodes must be positive."
    
        @assert 0 <= entanglement_prob <= 1 "Entanglement probability must be between 0 and 1."
        @assert 0 <= werner_prob <= 1       "Werner probability must be between 0 and 1."
        @assert 0 <= link_delay  "Link generation delay must be non-negative."
        
        return new(T2, num_end_nodes, entanglement_prob, werner_prob, link_delay)
    end
end

struct Network
    param::NetworkParam
    factory_node::FactoryNode
    end_nodes::Vector{EndNode}
end
function Network(param::NetworkParam)
    factory_node = FactoryNode(param.num_end_nodes, param.T2)
    end_nodes = [EndNode(param.T2) for _ in 1:param.num_end_nodes]
    return Network(param, factory_node, end_nodes)
end
function uptotime!(network::Network, time::Float64)
    for i in 1:network.param.num_end_nodes
        QuantumSavory.uptotime!(network.factory_node.link_qubits[i], time)
        QuantumSavory.uptotime!(network.factory_node.memory_qubits[i], time)
        QuantumSavory.uptotime!(network.end_nodes[i].qubit[1], time)
    end
end


include("processes/link_gen.jl")
include("processes/state_gen.jl")
include("processes/bsm.jl")

function run_sim(network::Network)
    total_time = 0.0

    link_time = 0.0
    for i in 1:network.param.num_end_nodes
        time_taken = link_gen(network, i)
        link_time = max(link_time, time_taken)
    end
    total_time += link_time

    state_gen(network)

    uptotime!(network, total_time)

    for i in 1:network.param.num_end_nodes
        bsm(network, i)
    end
    total_time += network.param.link_delay

    uptotime!(network, total_time)

    fidelity = GHZ_fidelity(network.end_nodes[1].qubit.staterefs[1].state[], network.param.num_end_nodes)

    return total_time, fidelity
end

export run_sim
export NetworkParam
export Network

end # module