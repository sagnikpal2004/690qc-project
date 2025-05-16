"""
    generate_ghz_state(N::Int) -> Ket

Generates an N-qubit GHZ state: (|0⟩^⊗N + |1⟩^⊗N) / √2
"""
function ghz_state(N::Int)
    @assert 2 ≤ N < 63 "N must be greater than 2"

    basis = SpinBasis(1//2)
    composite_basis = tensor([basis for _ in 1:N]...)

    # Initialize the state vector with zeros
    state_vector = zeros(Float64, 2^N)

    state_vector[1] = 1 / √2
    state_vector[end] = 1 / √2

    # Return the state as a Ket
    return Ket(composite_basis, state_vector)
end

function GHZ_fidelity(state::Operator, N::Int)
    ϕ_GHZ = ghz_state(N)
    return real(ϕ_GHZ' * state * ϕ_GHZ)
end
function GHZ_fidelity(state::Ket, N::Int)
    ϕ_GHZ = ghz_state(N)
    return abs(ϕ_GHZ' * state)^2
end