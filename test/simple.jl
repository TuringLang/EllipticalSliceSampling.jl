using EllipticalSliceSampling

using Distributions
using FillArrays

using Random
using Statistics
using Test

@testset "Scalar model" begin
    Random.seed!(1)

    # model
    prior = Normal(0, 1)
    ℓ(x) = logpdf(Normal(x, 0.5), 1.0)

    # true posterior
    μ = 0.8
    σ² = 0.2

    samples = ESS_mcmc(prior, ℓ, 2_000)

    @test mean(samples) ≈ μ atol=0.05
    @test var(samples) ≈ σ² atol=0.05
end

@testset "Scalar model with nonzero mean" begin
    Random.seed!(1)

    # model
    prior = Normal(0.5, 1)
    ℓ(x) = logpdf(Normal(x, 0.5), 1.0)

    # true posterior
    μ = 0.9
    σ² = 0.2

    samples = ESS_mcmc(prior, ℓ, 2_000)

    @test mean(samples) ≈ μ atol=0.05
    @test var(samples) ≈ σ² atol=0.05
end


@testset "Scalar model (vectorized)" begin
    Random.seed!(1)

    # model
    prior = MvNormal([0.0], 1.0)
    ℓ(x) = logpdf(MvNormal(x, 0.5), [1.0])

    # true posterior
    μ = [0.8]
    σ² = [0.2]

    samples = ESS_mcmc(prior, ℓ, 2_000)

    @test mean(samples) ≈ μ atol=0.05
    @test var(samples) ≈ σ² atol=0.05
end

@testset "Scalar model with nonzero mean (vectorized)" begin
    Random.seed!(1)

    # model
    prior = MvNormal([0.5], 1.0)
    ℓ(x) = logpdf(MvNormal(x, 0.5), [1.0])

    # true posterior
    μ = [0.9]
    σ² = [0.2]

    samples = ESS_mcmc(prior, ℓ, 2_000)

    @test mean(samples) ≈ μ atol=0.05
    @test var(samples) ≈ σ² atol=0.05
end