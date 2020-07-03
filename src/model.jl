# internal model structure consisting of prior, log-likelihood function, and a cache

struct ESSModel{P,L,C} <: AbstractMCMC.AbstractModel
    "Gaussian prior."
    prior::P
    "Log likelihood function."
    loglikelihood::L
    "Cache."
    cache::C

    function ESSModel{P,L}(prior::P, loglikelihood::L) where {P,L}
        isgaussian(P) ||
            error("prior distribution has to be a Gaussian distribution")

        # create cache
        c = cache(prior)

        new{P,L,typeof(c)}(prior, loglikelihood, c)
    end
end

ESSModel(prior, loglikelihood) =
    ESSModel{typeof(prior),typeof(loglikelihood)}(prior, loglikelihood)

# cache for high-dimensional samplers
function cache(dist)
    T = randtype(typeof(dist))

    # only create a cache if the distribution produces mutable samples
    ArrayInterface.ismutable(T) || return nothing

    similar(T, size(dist))
end

# test if a distribution is Gaussian
isgaussian(dist) = false

# unify element type of samplers
randtype(dist) = eltype(dist)

# evaluate the loglikelihood of a sample
Distributions.loglikelihood(model::ESSModel, f) = model.loglikelihood(f)

# sample from the prior
initial_sample(rng::Random.AbstractRNG, model::ESSModel) = rand(rng, model.prior)
function sample_prior(rng::Random.AbstractRNG, model::ESSModel)
    cache = model.cache

    if cache === nothing
        return rand(rng, model.prior)
    else
        Random.rand!(rng, model.prior, model.cache)
        return model.cache
    end
end

# compute the proposal
proposal(model::ESSModel, f, ν, θ) = proposal(model.prior, f, ν, θ)
proposal!(out, model::ESSModel, f, ν, θ) = proposal!(out, model.prior, f, ν, θ)

# default out-of-place implementation
function proposal(prior, f, ν, θ)
    sinθ, cosθ = sincos(θ)
    a = 1 - (sinθ + cosθ)
    μ = Statistics.mean(prior)
    return @. cosθ * f + sinθ * ν + a * μ
end

# default in-place implementation
proposal!(out, prior, f, ν, θ) = copyto!(out, proposal(prior, f, ν, θ))
