function werner_state(p::Float64)
    @assert 0 <= p <= 1 "p must be between 0 and 1."
    
    basis = SpinBasis(1//2)
    ϕ⁺ = Ket(basis ⊗ basis, [1.0+0.0im, 0.0+0.0im, 0.0+0.0im, 1.0+0.0im] / sqrt(2))
    return p * dm(ϕ⁺) + 0.25(1 - p) * express(I ⊗ I)
end
