export GaussianModel, ESS

# wrapper for prior and likelihood
struct GaussianModel{T,S,L}
    "Sampler of multivariate Gaussian prior."
    sampler::S
    "Log likelihood function."
    ℓ::L
end

GaussianModel(sampler, ℓ) =
    GaussianModel{eltype(sampler),typeof(sampler),typeof(ℓ)}(sampler, ℓ)

Base.eltype(::GaussianModel{T}) where T = T
Base.length(::GaussianModel) = length(GaussianModel.sampler)

Random.rand!(model::GaussianModel, x) = rand!(Random.GLOBAL_RNG, model, x)
Random.rand!(rng::AbstractRNG, model::GaussianModel, x) = rand!(rng, model.sampler, x)

Random.rand(model::GaussianModel) = rand(Random.GLOBAL_RNG, model)
Random.rand(rng::AbstractRNG, model::GaussianModel) = rand(rng, model.sampler)

# elliptical slice sampling algorithm
struct ESS{R,G<:GaussianModel}
    "Random number generator."
    rng::R
    "Gaussian model."
    model::G
end

ESS(rng::AbstractRNG, sampler, ℓ) = ESS(rng, GaussianModel(sampler, ℓ))
ESS(sampler, ℓ) = ESS(Random.GLOBAL_RNG, sampler, ℓ)
