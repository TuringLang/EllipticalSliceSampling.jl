# perform elliptical slice sampling for a fixed number of iterations
ESS_mcmc(prior, loglikelihood, N::Int; kwargs...) =
    ESS_mcmc(Random.GLOBAL_RNG, prior, loglikelihood, N; kwargs...)

function ESS_mcmc(rng::AbstractRNG, prior, loglikelihood, N::Int; burnin::Int = 0)
    # define the internal model
    model = Model(prior, loglikelihood)

    # create the sampler
    sampler = EllipticalSliceSampler(rng, model)

    # create MCMC chain
    chain = Vector{eltype(sampler)}(undef, N)
    niters = N + burnin
    @withprogress name = "Performing elliptical slice sampling" begin
        # discard burnin phase
        for (i, _) in zip(1:burnin, sampler)
            @logprogress i / niters
        end

        for (i, f) in zip(1:N, sampler)
            @inbounds chain[i] = f
            @logprogress (i + burnin) / niters
        end
    end

    chain
end

# create an elliptical slice sampler
ESS_mcmc_sampler(prior, loglikelihood) = ESS_mcmc_sampler(Random.GLOBAL_RNG, prior, loglikelihood)
ESS_mcmc_sampler(rng::AbstractRNG, prior, loglikelihood) =
    EllipticalSliceSampler(rng, Model(prior, loglikelihood))
