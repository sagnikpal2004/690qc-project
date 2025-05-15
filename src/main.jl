using QuantumSavory
using QuantumOptics

struct FactoryNode 
    memory_qubits::Register
    link_qubits::Register
end
function FactoryNode(num_qubits::Int)
    @assert num_qubits > 0 "Number of qubits must be positive."
    return FactoryNode(Register(num_qubits), Register(num_qubits))
end

struct EndNode
    qubit::Register
end
function EndNode()
    reg = Register(1)
    return EndNode(reg)
end

struct NetworkParam
    num_end_nodes::Int

    entanglement_prob::Float64
    werner_prob::Float64
    link_generation_delay::Float64

    function NetworkParam(;
        num_end_nodes::Int, 

        entanglement_prob::Float64 = 1.0,
        werner_prob::Float64 = 0.0,
        link_generation_delay::Float64 = 0.0
    )
        @assert 0 <  num_end_nodes          "Number of end nodes must be positive."
    
        @assert 0 <= entanglement_prob <= 1 "Entanglement probability must be between 0 and 1."
        @assert 0 <= werner_prob <= 1       "Werner probability must be between 0 and 1."
        @assert 0 <= link_generation_delay  "Link generation delay must be non-negative."
        
        return new(num_end_nodes, entanglement_prob, link_generation_delay)
    end
end

struct Network
    param::NetworkParam
    factory_node::FactoryNode
    end_nodes::Vector{EndNode}
end
function Network(param::NetworkParam)
    factory_node = FactoryNode(param.num_end_nodes)
    end_nodes = [EndNode() for _ in 1:param.num_end_nodes]
    return Network(param, factory_node, end_nodes)
end


include("processes/link_gen.jl")

function run_sim(network::Network)
    total_time = 0.0

    link_time = 0.0
    for i in 1:network.param.num_end_nodes
        time_taken = link_gen(network, i)
        link_time = max(link_time, time_taken)
    end
    total_time += link_time

    return total_time
end

# TESTING

param = NetworkParam(
    num_end_nodes = 3,
    entanglement_prob = 1.0,
    werner_prob = 1.0,
    link_generation_delay = 0.0
)
network = Network(param)
total_time = run_sim(network)

println(total_time)