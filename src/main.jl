using QuantumSavory

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
    initialize!(reg[1])
    return EndNode(reg)
end

struct NetworkParam
    entanglement_prob::Float64
end
function NetworkParam(entanglement_prob::Float64)
    @assert 0 <= entanglement_prob <= 1 "Entanglement probability must be between 0 and 1."
    return NetworkParam(entanglement_prob)
end

struct Network
    param::NetworkParam
    factory_node::FactoryNode
    end_nodes::Vector{EndNode}
end