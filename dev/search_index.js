var documenterSearchIndex = {"docs":
[{"location":"#EllipticalSliceSampling","page":"Home","title":"EllipticalSliceSampling","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Julia implementation of elliptical slice sampling.","category":"page"},{"location":"#Overview","page":"Home","title":"Overview","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package implements elliptical slice sampling in the Julia language, as described in Murray, Adams & MacKay (2010).","category":"page"},{"location":"","page":"Home","title":"Home","text":"Elliptical slice sampling is a \"Markov chain Monte Carlo algorithm for performing inference in models with multivariate Gaussian priors\" (Murray, Adams & MacKay (2010)).","category":"page"},{"location":"","page":"Home","title":"Home","text":"Without loss of generality, the originally described algorithm assumes that the Gaussian prior has zero mean. For convenience we allow the user to specify arbitrary Gaussian priors with non-zero means and handle the change of variables internally.","category":"page"},{"location":"#Poster-at-JuliaCon-2021","page":"Home","title":"Poster at JuliaCon 2021","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"(Image: EllipticalSliceSampling.jl: MCMC with Gaussian priors)","category":"page"},{"location":"","page":"Home","title":"Home","text":"The slides are available as Pluto notebook.","category":"page"},{"location":"#Usage","page":"Home","title":"Usage","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Probably most users would like to generate a MC Markov chain of samples from the posterior distribution by calling","category":"page"},{"location":"","page":"Home","title":"Home","text":"sample([rng, ]ESSModel(prior, loglikelihood), ESS(), N[; kwargs...])","category":"page"},{"location":"","page":"Home","title":"Home","text":"which returns a vector of N samples for approximating the posterior of a model with a Gaussian prior that allows sampling from the prior and evaluation of the log likelihood loglikelihood.","category":"page"},{"location":"","page":"Home","title":"Home","text":"You can sample multiple chains in parallel with multiple threads or processes by running","category":"page"},{"location":"","page":"Home","title":"Home","text":"sample([rng, ]ESSModel(prior, loglikelihood), ESS(), MCMCThreads(), N, nchains[; kwargs...])","category":"page"},{"location":"","page":"Home","title":"Home","text":"or","category":"page"},{"location":"","page":"Home","title":"Home","text":"sample([rng, ]ESSModel(prior, loglikelihood), ESS(), MCMCDistributed(), N, nchains[; kwargs...])","category":"page"},{"location":"","page":"Home","title":"Home","text":"If you want to have more control about the sampling procedure (e.g., if you only want to save a subset of samples or want to use another stopping criterion), the function","category":"page"},{"location":"","page":"Home","title":"Home","text":"AbstractMCMC.steps(\n    [rng,]\n    ESSModel(prior, loglikelihood),\n    ESS();\n    kwargs...\n)","category":"page"},{"location":"","page":"Home","title":"Home","text":"gives you access to an iterator from which you can generate an unlimited number of samples.","category":"page"},{"location":"","page":"Home","title":"Home","text":"You can define the starting point of your chain using the initial_params keyword argument.","category":"page"},{"location":"","page":"Home","title":"Home","text":"For more details regarding sample and steps please check the documentation of AbstractMCMC.jl.","category":"page"},{"location":"#Prior","page":"Home","title":"Prior","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"You may specify Gaussian priors with arbitrary means. EllipticalSliceSampling.jl provides first-class support for the scalar and multivariate normal distributions in Distributions.jl. For instance, if the prior distribution is a standard normal distribution, you can choose","category":"page"},{"location":"","page":"Home","title":"Home","text":"prior = Normal()","category":"page"},{"location":"","page":"Home","title":"Home","text":"However, custom Gaussian priors are supported as well. For instance, if you want to use a custom distribution type GaussianPrior, the following methods should be implemented:","category":"page"},{"location":"","page":"Home","title":"Home","text":"# state that the distribution is actually Gaussian\nEllipticalSliceSampling.isgaussian(::Type{<:GaussianPrior}) = true\n\n# define the mean of the distribution\n# alternatively implement `proposal(prior, ...)` and\n# `proposal!(out, prior, ...)` (only if the samples are mutable)\nStatistics.mean(dist::GaussianPrior) = ...\n\n# define how to sample from the distribution\n# only one of the following methods is needed:\n# - if the samples are immutable (e.g., numbers or static arrays) only\n#   `rand(rng, dist)` should be implemented\n# - otherwise only `rand!(rng, dist, sample)` is required\nBase.rand(rng::AbstractRNG, dist::GaussianPrior) = ...\nRandom.rand!(rng::AbstractRNG, dist::GaussianPrior, sample) = ...","category":"page"},{"location":"#Log-likelihood","page":"Home","title":"Log likelihood","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"In addition to the prior, you have to specify a Julia implementation of the log likelihood function. Here the predefined log densities and log likelihood functions in Distributions.jl might be useful.","category":"page"},{"location":"#Progress-monitor","page":"Home","title":"Progress monitor","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"If you use a package such as Juno or TerminalLoggers.jl that supports progress logs created by the ProgressLogging.jl API, then you can monitor the progress of the sampling algorithm. If you do not specify a progress logging frontend explicitly, AbstractMCMC.jl picks a frontend for you automatically.","category":"page"},{"location":"#References","page":"Home","title":"References","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Murray, I., Adams, R. & MacKay, D.. (2010). Elliptical slice sampling. Proceedings of Machine Learning Research, 9:541-548.","category":"page"}]
}
