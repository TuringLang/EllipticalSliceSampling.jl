using Distances: pairwise, SqEuclidean
using EllipticalSliceSampling
using StatsFuns: normlogpdf

using LinearAlgebra
using Random
using Statistics

Random.seed!(0)

# sample from Cholesky decomposition
struct ZeroMeanGaussian{C<:Cholesky}
    Σ::C
end

ZeroMeanGaussian(Σ::AbstractMatrix) = ZeroMeanGaussian(cholesky(Σ))

Base.eltype(::Type{ZeroMeanGaussian}) = Float64
Base.length(g::ZeroMeanGaussian) = size(g.Σ, 1)

Random.rand!(rng::AbstractRNG, g::ZeroMeanGaussian, x::AbstractVector) =
    lmul!(g.Σ.L, randn!(rng, x))
Random.rand(rng::AbstractRNG, g::ZeroMeanGaussian) = lmul!(g.Σ.L, randn(rng, length(g)))

@testset "Example from Murray et al." begin
    N = 200 # number of input features
    σ = 0.3 # observation noise

    # for different dimensions of input features
    for d in 1:10
        # sample input features
        inputs = rand(d, N)

        # define covariance matrix of latent variable
        prior_Σ = Symmetric(exp.((-0.5) .* pairwise(SqEuclidean(), inputs)))
        prior = ZeroMeanGaussian(prior_Σ + 100 * eps() * I) # noise due to numerical issues

        # sample noisy observations
        observations = rand(prior) .+ σ .* randn(N)

        # define log likelihood function
        ℓ(f) = sum(normlogpdf(fᵢ, σ, obsᵢ) for (fᵢ, obsᵢ) in zip(f, observations))

        # run elliptical slice sampling
        samples = ESS_mcmc(prior, ℓ, 10_000)

        # compute empirical mean and covariance matrix of samples
        μ̂, Σ̂ = mean(view(samples, 1_001:10_000)), cov(view(samples, 1_001:10_000))

        # compute analytical posterior
        F = factorize(prior_Σ + σ^2 * I)
        posterior_μ = prior_Σ * (F \ observations)
        posterior_Σ = Symmetric(prior_Σ * (I - F \ prior_Σ))

        # TODO: decrease error tolerances
        @test μ̂ ≈ posterior_μ atol=2.0
        @test Σ̂ ≈ posterior_Σ atol=2.0
    end
end
