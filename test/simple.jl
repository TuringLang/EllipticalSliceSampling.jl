@testset "simple.jl" begin

    # Load all required packages and define likelihood functions
    ℓ(x) = logpdf(Normal(x, 0.5), 1.0)
    ℓvec(x) = logpdf(MvNormal(x, 0.25 * I), [1.0])
    @everywhere begin
        ℓ(x) = logpdf(Normal(x, 0.5), 1.0)
        ℓvec(x) = logpdf(MvNormal(x, 0.25 * I), [1.0])
    end

    @testset "Scalar model" begin
        Random.seed!(1)

        # model
        prior = Normal(0, 1)

        # true posterior
        μ = 0.8
        σ² = 0.2

        # regular sampling
        samples = sample(ESSModel(prior, ℓ), ESS(), 2_000; progress=false)
        @test samples isa Vector{Float64}
        @test length(samples) == 2_000
        @test mean(samples) ≈ μ atol = 0.05
        @test var(samples) ≈ σ² atol = 0.05

        # parallel sampling
        for alg in (MCMCThreads(), MCMCDistributed(), MCMCSerial())
            samples = sample(ESSModel(prior, ℓ), ESS(), alg, 2_000, 5; progress=false)
            @test samples isa Vector{Vector{Float64}}
            @test length(samples) == 5
            @test all(length(x) == 2_000 for x in samples)
            @test mean(mean, samples) ≈ μ atol = 0.05
            @test mean(var, samples) ≈ σ² atol = 0.05

            # initial parameter
            init_x = randn(5)
            samples = sample(
                ESSModel(prior, ℓ), ESS(), alg, 10, 5; progress=false, init_params=init_x
            )
            @test map(first, samples) == init_x
        end

        # initial parameter
        init_x = randn()
        samples = sample(ESSModel(prior, ℓ), ESS(), 10; progress=false, init_params=init_x)
        @test first(samples) == init_x
    end

    @testset "Scalar model with nonzero mean" begin
        Random.seed!(1)

        # model
        prior = Normal(0.5, 1)

        # true posterior
        μ = 0.9
        σ² = 0.2

        # regular sampling
        samples = sample(ESSModel(prior, ℓ), ESS(), 2_000; progress=false)
        @test samples isa Vector{Float64}
        @test length(samples) == 2_000
        @test mean(samples) ≈ μ atol = 0.05
        @test var(samples) ≈ σ² atol = 0.05

        # parallel sampling
        for alg in (MCMCThreads(), MCMCDistributed(), MCMCSerial())
            samples = sample(ESSModel(prior, ℓ), ESS(), alg, 2_000, 5; progress=false)
            @test samples isa Vector{Vector{Float64}}
            @test length(samples) == 5
            @test all(length(x) == 2_000 for x in samples)
            @test mean(mean, samples) ≈ μ atol = 0.05
            @test mean(var, samples) ≈ σ² atol = 0.05

            # initial parameter
            init_x = randn(5)
            samples = sample(
                ESSModel(prior, ℓ), ESS(), alg, 10, 5; progress=false, init_params=init_x
            )
            @test map(first, samples) == init_x
        end

        # initial parameter
        init_x = randn()
        samples = sample(ESSModel(prior, ℓ), ESS(), 10; progress=false, init_params=init_x)
        @test first(samples) == init_x
    end

    @testset "Scalar model (vectorized)" begin
        Random.seed!(1)

        # model
        prior = MvNormal([0.0], I)

        # true posterior
        μ = [0.8]
        σ² = [0.2]

        # regular sampling
        samples = sample(ESSModel(prior, ℓvec), ESS(), 2_000; progress=false)
        @test samples isa Vector{Vector{Float64}}
        @test length(samples) == 2_000
        @test all(length(x) == 1 for x in samples)
        @test mean(samples) ≈ μ atol = 0.05
        @test var(samples) ≈ σ² atol = 0.05

        # parallel sampling
        for alg in (MCMCThreads(), MCMCDistributed(), MCMCSerial())
            samples = sample(ESSModel(prior, ℓvec), ESS(), alg, 2_000, 5; progress=false)
            @test samples isa Vector{Vector{Vector{Float64}}}
            @test length(samples) == 5
            @test all(length(x) == 2_000 for x in samples)
            @test mean(mean, samples) ≈ μ atol = 0.05
            @test mean(var, samples) ≈ σ² atol = 0.05

            # initial parameter
            init_x = [randn(1) for _ in 1:5]
            samples = sample(
                ESSModel(prior, ℓvec), ESS(), alg, 10, 5; progress=false, init_params=init_x
            )
            @test map(first, samples) == init_x
        end

        # initial parameter
        init_x = randn(1)
        samples = sample(
            ESSModel(prior, ℓvec), ESS(), 10; progress=false, init_params=init_x
        )
        @test first(samples) == init_x
    end

    @testset "Scalar model with nonzero mean (vectorized)" begin
        Random.seed!(1)

        # model
        prior = MvNormal([0.5], I)

        # true posterior
        μ = [0.9]
        σ² = [0.2]

        # regular sampling
        samples = sample(ESSModel(prior, ℓvec), ESS(), 2_000; progress=false)
        @test samples isa Vector{Vector{Float64}}
        @test length(samples) == 2_000
        @test all(length(x) == 1 for x in samples)
        @test mean(samples) ≈ μ atol = 0.05
        @test var(samples) ≈ σ² atol = 0.05

        # parallel sampling
        for alg in (MCMCThreads(), MCMCDistributed(), MCMCSerial())
            samples = sample(ESSModel(prior, ℓvec), ESS(), alg, 2_000, 5; progress=false)
            @test samples isa Vector{Vector{Vector{Float64}}}
            @test length(samples) == 5
            @test all(length(x) == 2_000 for x in samples)
            @test mean(mean, samples) ≈ μ atol = 0.05
            @test mean(var, samples) ≈ σ² atol = 0.05

            # initial parameter
            init_x = [randn(1) for _ in 1:5]
            samples = sample(
                ESSModel(prior, ℓvec), ESS(), alg, 10, 5; progress=false, init_params=init_x
            )
            @test map(first, samples) == init_x
        end

        # initial parameter
        init_x = randn(1)
        samples = sample(
            ESSModel(prior, ℓvec), ESS(), 10; progress=false, init_params=init_x
        )
        @test first(samples) == init_x
    end
end
