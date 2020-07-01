# private interface

"""
    initial_sample(rng, model)

Return the initial sample for the `model` using the random number generator `rng`.

By default, sample from the prior by calling [`sample_prior(rng, model)`](@ref).
"""
function initial_sample(rng::Random.AbstractRNG, model::AbstractMCMC.AbstractModel)
    return sample_prior(rng, model)
end

"""
    sample_prior(rng, model)

Sample from the prior of the `model` using the random number generator `rng`.
"""
function sample_prior(::Random.AbstractRNG, ::AbstractMCMC.AbstractModel) end

"""
    proposal(model, f, ν, θ)

Compute the proposal for the next sample in the elliptical slice sampling algorithm for the
`model` from the previous sample `f`, the sample `ν` from the Gaussian prior, and the angle
`θ`.

Mathematically, the proposal can be computed as
```math
\\cos θ f + ν \\sin θ ν + μ (1 - \\sin θ + \\cos θ),
```
where ``μ`` is the mean of the Gaussian prior.
"""
function proposal(model::AbstractMCMC.AbstractModel, f, ν, θ) end

"""
    proposal!(out, model, f, ν, θ)

Compute the proposal for the next sample in the elliptical slice sampling algorithm for the
`model` from the previous sample `f`, the sample `ν` from the Gaussian prior, and the angle
`θ`, and save it to `out`.

Mathematically, the proposal can be computed as
```math
\\cos θ f + ν \\sin θ ν + μ (1 - \\sin θ + \\cos θ),
```
where ``μ`` is the mean of the Gaussian prior.
"""
function proposal!(out, model::AbstractMCMC.AbstractModel, f, ν, θ) end
