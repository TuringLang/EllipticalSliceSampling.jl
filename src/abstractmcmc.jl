# elliptical slice sampler
struct ESS <: AbstractMCMC.AbstractSampler end

# state of the elliptical slice sampler
struct ESSState{S,L,C}
    "Sample of the elliptical slice sampler."
    sample::S
    "Log-likelihood of the sample."
    loglikelihood::L
    "Cache used for in-place sampling."
    cache::C
end

function ESSState(sample, loglikelihood)
    # create cache since it was not provided (initial sampling step)
    cache = ArrayInterface.ismutable(sample) ? similar(sample) : nothing
    return ESSState(sample, loglikelihood, cache)
end

# first step of the elliptical slice sampler
function AbstractMCMC.step(
    rng::Random.AbstractRNG, model::AbstractMCMC.AbstractModel, ::ESS; kwargs...
)
    # initial sample from the Gaussian prior
    f = initial_sample(rng, model; kwargs...)

    # compute log-likelihood of the initial sample
    loglikelihood = Distributions.loglikelihood(model, f)

    return f, ESSState(f, loglikelihood)
end

# subsequent steps of the elliptical slice sampler
function AbstractMCMC.step(
    rng::Random.AbstractRNG,
    model::AbstractMCMC.AbstractModel,
    ::ESS,
    state::ESSState;
    kwargs...,
)
    # obtain the prior
    prior = EllipticalSliceSampling.prior(model)

    # sample from Gaussian prior
    cache = state.cache
    if cache === nothing
        ν = Random.rand(rng, prior)
    else
        Random.rand!(rng, prior, cache)
        ν = cache
    end

    # sample log-likelihood threshold
    loglikelihood = state.loglikelihood
    threshold = loglikelihood - Random.randexp(rng)

    # sample initial angle
    θ = 2 * π * rand(rng)
    θmin = θ - 2 * π
    θmax = θ

    # compute the proposal
    f = state.sample
    fnext = proposal(prior, f, ν, θ)

    # compute the log-likelihood of the proposal
    loglikelihood = Distributions.loglikelihood(model, fnext)

    # stop if the log-likelihood threshold is reached
    while loglikelihood < threshold
        # shrink the bracket
        if θ < zero(θ)
            θmin = θ
        else
            θmax = θ
        end

        # sample angle
        θ = θmin + rand(rng) * (θmax - θmin)

        # recompute the proposal
        if ArrayInterface.ismutable(fnext)
            proposal!(fnext, prior, f, ν, θ)
        else
            fnext = proposal(prior, f, ν, θ)
        end

        # compute the log-likelihood of the proposal
        loglikelihood = Distributions.loglikelihood(model, fnext)
    end

    return fnext, ESSState(fnext, loglikelihood, cache)
end
