export ESS_mcmc

"""
    mcmc(ess:ESS, N::Int)

Run the elliptical slice sampler `ess` for `N` iterations and return the samples as a
vector.
"""
function mcmc(ess::ESS, N::Int)
    rng = ess.rng
    sampler, ℓ = ess.model.sampler, ess.model.ℓ

    # initial sample from multivariate Gaussian prior
    f = rand(rng, sampler)
    samples = Vector{typeof(f)}(undef, N)
    samples[1] = f

    # compute log likelihood of initial sample
    ℓf = ℓ(f)

    # for all iterations
    ν = similar(f)
    @inbounds for i in 2:N
        # sample from multivariate Gaussian prior
        rand!(rng, sampler, ν)

        # sample log likelihood threshold
        ℓthreshold = ℓf - randexp(rng)

        # sample initial angle
        θ = twoπ * rand(rng)
        θₘᵢₙ, θₘₐₓ = θ - twoπ, θ

        # compute proposal f´
        sinθ, cosθ = sincos(θ)
        f´ = @. f * cosθ + ν * sinθ

        # compute log likelihood of proposal f´
        ℓf = ℓ(f´)

        # while log likelihood threshold is not reached
        while ℓf < ℓthreshold
            # shrink the bracket
            if θ < 0
                θₘᵢₙ = θ
            else
                θₘₐₓ = θ
            end

            # sample angle
            θ = θₘᵢₙ + rand(rng) * (θₘₐₓ - θₘᵢₙ)

            # update proposal f´
            sinθ, cosθ = sincos(θ)
            @. f´ = f * cosθ + ν * sinθ

            # update log likelihood of proposal f´
            ℓf = ℓ(f´)
        end

        # update state and save it
        f = f´
        samples[i] = f
    end

    samples
end

"""
    ESS_mcmc(rng::AbstractRNG, sampler, ℓ, N::Int)

Init and then draw `N` samples from the `sampler` of the multivariate Gausian prior with
log density `ℓ` using the elliptical slice sampling algorithm.

Return the *samples*.

`rng` is the random number generator.
"""
ESS_mcmc(rng::AbstractRNG, sampler, ℓ, N::Int) = mcmc(ESS(rng, sampler, ℓ), N)

"""
    ESS_mcmc(sampler, ℓ, N::Int)

Same as the other method but with random number generator `Random.GLOBAL_RNG`.
"""
ESS_mcmc(sampler, ℓ, N::Int) = ESS_mcmc(Random.GLOBAL_RNG, sampler, ℓ, N)
