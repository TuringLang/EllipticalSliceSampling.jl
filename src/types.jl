# elliptical slice sampling algorithm

# internal model structure consisting of prior and log-likelihood function
struct Model{P,L}
    "Gaussian prior."
    prior::P
    "Log likelihood function."
    loglikelihood::L

    function Model{P,L}(prior::P, loglikelihood::L) where {P,L}
        isnormal(prior) ||
            error("prior distribution has to be a normal distribution")

        new{P,L}(prior, loglikelihood)
    end
end

Model(prior, loglikelihood) =
    Model{typeof(prior),typeof(loglikelihood)}(prior, loglikelihood)

# use custom randtype since behaviour of `eltype` is inconsistent in Distributions
Base.eltype(::Type{<:Model{P}}) where P = randtype(P)

# elliptical slice sampler
struct EllipticalSliceSampler{M<:Model,R<:AbstractRNG,C}
    "Random number generator."
    rng::R
    "Model."
    model::M
    "Cache."
    cache::C
end

EllipticalSliceSampler(model::Model) = EllipticalSliceSampler(Random.GLOBAL_RNG, model)
EllipticalSliceSampler(rng::AbstractRNG, model::Model) =
    EllipticalSliceSampler(rng, model, cache(model.prior))

Base.eltype(::Type{<:EllipticalSliceSampler{M}}) where M = eltype(M)

# set seed of the sampler
Random.seed!(ess::EllipticalSliceSampler) = Random.seed!(ess.rng)

# state of the elliptical slice sampler
struct EllipticalSliceSamplerState{F,L}
    "Sample of the elliptical slice sampler."
    f::F
    "Log-likelihood of the sample."
    ℓ::L
end
