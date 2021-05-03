@testset "regression.jl" begin

    # number of input features
    N = 200
    # homoscedastic observation noise
    σ = 0.3

    # experiment of Murray et al.
    @testset "GP regression" begin
        # added to the diagonal of the covariance matrix due to numerical issues of
        # the Cholesky decomposition
        jitter = 1e-9

        # for different dimensions of input features
        for d in 1:10
            # sample input features
            inputs = rand(d, N)

            # define covariance matrix of latent variable
            # add noise to the diagonal due to numerical issues
            prior_Σ =
                Symmetric(exp.((-0.5) .* pairwise(SqEuclidean(), inputs; dims=2))) +
                jitter * I
            prior = MvNormal(prior_Σ)

            # sample noisy observations
            observations = rand(prior) .+ σ .* randn(N)

            # define log likelihood function
            ℓ(f) =
                let observations = observations, σ = σ
                    logpdf(MvNormal(f, σ), observations)
                end

            # run elliptical slice sampler for 100 000 time steps
            samples = sample(ESSModel(prior, ℓ), ESS(), 100_000; progress=false)

            # compute analytical posterior of GP
            posterior_Σ = prior_Σ * (I - (prior_Σ + σ^2 * I) \ prior_Σ)
            posterior_μ = posterior_Σ * observations / σ^2

            # compare with empirical estimates
            @test mean(samples) ≈ posterior_μ rtol = 0.05
        end
    end

    # extreme case with independent observations
    @testset "Independent components" begin
        # define  distribution of latent variables
        prior = MvNormal(N, 1)

        # sample noisy observations
        observations = rand(prior) .+ σ .* randn(N)

        # define log likelihood function
        ℓ(f) =
            let observations = observations, σ = σ
                logpdf(MvNormal(f, σ), observations)
            end

        # run elliptical slice sampling for 100 000 time steps
        samples = sample(ESSModel(prior, ℓ), ESS(), 100_000; progress=false)

        # compute analytical posterior
        posterior_μ = observations / (1 + σ^2)

        # compare with empirical estimates
        @test mean(samples) ≈ posterior_μ rtol = 0.02
    end
end
