Base.IteratorSize(::Type{<:EllipticalSliceSampler}) = Base.IsInfinite()

function Base.iterate(ess::EllipticalSliceSampler)
    @unpack rng, model = ess
    @unpack prior, loglikelihood = model

    # initial sample from the Gaussian prior
    f = rand(rng, prior)

    # compute log-likelihood of the initial sample
    ℓ = loglikelihood(f)

    f, EllipticalSliceSamplerState(f, ℓ)
end

function Base.iterate(ess::EllipticalSliceSampler, state::EllipticalSliceSamplerState)
    @unpack rng, model, cache = ess
    @unpack prior, loglikelihood = model
    @unpack f, ℓ = state

    # sample from Gaussian prior
    if cache === nothing
        ν = rand(rng, prior)
    else
        rand!(rng, prior, cache)
        ν = cache
    end

    # sample log-likelihood threshold
    logy = ℓ - randexp(rng)

    # sample initial angle
    θ = 2 * π * rand(rng)
    θₘᵢₙ = θ - 2 * π
    θₘₐₓ = θ

    # obtain mean of prior
    μ = mean(prior)

    # compute the proposal
    # we apply a correction for Gaussian distributions with non-zero mean
    sinθ, cosθ = sincos(θ)
    a = 1 - (sinθ + cosθ)
    fnext = @. f * cosθ + ν * sinθ + a * μ

    # compute the log-likelihood of the proposal
    ℓ = loglikelihood(fnext)

    # stop if the log-likelihood threshold is reached
    while ℓ < logy
        # shrink the bracket
        if θ < zero(θ)
            θₘᵢₙ = θ
        else
            θₘₐₓ = θ
        end

        # sample angle
        θ = θₘᵢₙ + rand(rng) * (θₘₐₓ - θₘᵢₙ)

        # recompute the proposal
        # we apply a correction for Gaussian distributions with non-zero mean
        sinθ, cosθ = sincos(θ)
        a = 1 - (sinθ + cosθ)
        if ArrayInterface.ismutable(fnext)
            @. fnext = f * cosθ + ν * sinθ + a * μ
        else
            fnext = @. f * cosθ + ν * sinθ + a * μ
        end

        # compute the log-likelihood of the proposal
        ℓ = loglikelihood(fnext)
    end

    return fnext, EllipticalSliceSamplerState(fnext, ℓ)
end
