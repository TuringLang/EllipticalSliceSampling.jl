# private interface

"""
    isgaussian(dist)

Check if distribution `dist` is a Gaussian distribution.
"""
isgaussian(dist) = false
isgaussian(::Type{<:Distributions.Normal}) = true
isgaussian(::Type{<:Distributions.NormalCanon}) = true
isgaussian(::Type{<:Distributions.AbstractMvNormal}) = true

"""
    prior(model)

Return the prior distribution of the `model`.
"""
function prior(::AbstractMCMC.AbstractModel) end

"""
    initial_sample(rng, model)

Return the initial sample for the `model` using the random number generator `rng`.

By default, sample from [`prior(model)`](@ref).
"""
function initial_sample(
    rng::Random.AbstractRNG, model::AbstractMCMC.AbstractModel; kwargs...
)
    return Random.rand(rng, prior(model))
end

"""
    proposal(prior, f, ν, θ)

Compute the proposal for the next sample in the elliptical slice sampling algorithm.

Mathematically, the proposal can be computed as
```math
f \\cos θ + ν \\sin θ + μ (1 - (\\sin θ + \\cos θ)),
```
where ``μ`` is the mean of the Gaussian `prior`, `f` is the previous sample, and `ν` is a
sample from the Gaussian `prior`.

See also: [`proposal!`](@ref)
"""
function proposal(prior, f, ν, θ)
    sinθ, cosθ = sincos(θ)
    a = 1 - (sinθ + cosθ)
    μ = Statistics.mean(prior)
    return @. cosθ * f + sinθ * ν + a * μ
end

"""
    proposal!(out, model, f, ν, θ)

Compute the proposal for the next sample in the elliptical slice sampling algorithm, and
save it to `out`.

Mathematically, the proposal can be computed as
```math
f \\cos θ + ν \\sin θ + μ (1 - (\\sin θ + \\cos θ)),
```
where ``μ`` is the mean of the Gaussian `prior`, `f` is the previous sample, and `ν` is a
sample from the Gaussian `prior`.

See also: [`proposal`](@ref)
"""
function proposal!(out, prior, f, ν, θ)
    sinθ, cosθ = sincos(θ)
    a = 1 - (sinθ + cosθ)
    μ = Statistics.mean(prior)
    @. out = cosθ * f + sinθ * ν + a * μ
    return out
end
