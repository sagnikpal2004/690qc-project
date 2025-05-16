function bsm(network::Network, link_id::Int)
    apply!([network.factory_node.link_qubits[link_id], network.factory_node.memory_qubits[link_id]], CNOT)
    apply!(network.factory_node.link_qubits[link_id], H)

    measa = project_traceout!(network.factory_node.link_qubits[link_id], σᶻ)
    measb = project_traceout!(network.factory_node.memory_qubits[link_id], σᶻ)

    if measa == 2
        apply!(network.end_nodes[link_id].qubit[1], X)
    end
    if measb == 2
        apply!(network.end_nodes[link_id].qubit[1], Z)
    end
end