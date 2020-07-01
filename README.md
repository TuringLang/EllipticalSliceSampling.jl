# EllipticalSliceSampling.jl

Julia implementation of elliptical slice sampling.

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Build Status](https://travis-ci.com/TuringLang/EllipticalSliceSampling.jl.svg?branch=master)](https://travis-ci.com/TuringLang/EllipticalSliceSampling.jl)
[![Build Status](https://github.com/TuringLang/EllipticalSliceSampling.jl/workflows/CI/badge.svg)](https://github.com/TuringLang/EllipticalSliceSampling.jl/actions?query=workflow%3ACI)
[![Codecov](https://codecov.io/gh/TuringLang/EllipticalSliceSampling.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/TuringLang/EllipticalSliceSampling.jl)
[![Coveralls](https://coveralls.io/repos/github/TuringLang/EllipticalSliceSampling.jl/badge.svg?branch=master)](https://coveralls.io/github/TuringLang/EllipticalSliceSampling.jl?branch=master)

## Overview

This package implements elliptical slice sampling in the Julia language, as described in
[Murray, Adams & MacKay (2010)](http://proceedings.mlr.press/v9/murray10a/murray10a.pdf).

Elliptical slice sampling is a "Markov chain Monte Carlo algorithm for performing
inference in models with multivariate Gaussian priors" (Murray, Adams & MacKay (2010)).

Without loss of generality, the originally described algorithm assumes that the Gaussian
prior has zero mean. For convenience we allow the user to specify arbitrary Gaussian
priors with non-zero means and handle the change of variables internally.

## Usage

Probably most users would like to generate a MC Markov chain of samples from
the posterior distribution by calling
```julia
sample([rng, ]ESSModel(prior, loglikelihood), ESS(), N[; kwargs...])
```
which returns a vector of `N` samples for approximating the posterior of
a model with a Gaussian prior that allows sampling from the `prior` and
evaluation of the log likelihood `loglikelihood`.

If you want to have more control about the sampling procedure (e.g., if you
only want to save a subset of samples or want to use another stopping
criterion), the function
```julia
AbstractMCMC.steps(
    [rng,]
    ESSModel(prior, loglikelihood),
    ESS();
    kwargs...
)
```
gives you access to an iterator from which you can generate an unlimited
number of samples.

### Prior

You may specify Gaussian priors with arbitrary means. EllipticalSliceSampling.jl
provides first-class support for the scalar and multivariate normal distributions
in [Distributions.jl](https://github.com/JuliaStats/Distributions.jl). For
instance, if the prior distribution is a standard normal distribution, you can
choose
```julia
prior = Normal()
```

However, custom Gaussian priors are supported as well. For instance, if you want to
use a custom distribution type `GaussianPrior`, the following methods should be
implemented:
```julia
# state that the distribution is actually Gaussian
EllipticalSliceSampling.isgaussian(::Type{<:GaussianPrior}) = true

# define the mean of the distribution
# alternatively implement `proposal(prior, ...)` and
# `proposal!(out, prior, ...)` (only if the samples are mutable)
Statistics.mean(dist::GaussianPrior) = ...

# define how to sample from the distribution
# only one of the following methods is needed:
# - if the samples are immutable (e.g., numbers or static arrays) only
#   `rand(rng, dist)` should be implemented
# - otherwise only `rand!(rng, dist, sample)` is required
Base.rand(rng::AbstractRNG, dist::GaussianPrior) = ...
Random.rand!(rng::AbstractRNG, dist::GaussianPrior, sample) = ...

# specify the type of a sample from the distribution
Base.eltype(::Type{<:GaussianPrior}) = ...

# in the case of mutable samples, specify the array size of the samples
Base.size(dist::GaussianPrior) = ...
```

### Log likelihood

In addition to the prior, you have to specify a Julia implementation of
the log likelihood function. Here the predefined log densities and log
likelihood functions in
[Distributions.jl](https://github.com/JuliaStats/Distributions.jl) might
be useful.

### Progress monitor

If you use a package such as [Juno](https://junolab.org/) or
[TerminalLoggers.jl](https://github.com/c42f/TerminalLoggers.jl) that supports
progress logs created by the
[ProgressLogging.jl](https://github.com/JunoLab/ProgressLogging.jl) API, then you can
monitor the progress of the sampling algorithm. If you do not specify a progress
logging frontend explicitly,
[AbstractMCMC.jl](https://github.com/TuringLang/AbstractMCMC.jl) picks a frontend
for you automatically.

## Bibliography

Murray, I., Adams, R. & MacKay, D.. (2010). Elliptical slice sampling. Proceedings of Machine Learning Research, 9:541-548.
