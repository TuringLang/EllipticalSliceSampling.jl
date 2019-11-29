# EllipticalSliceSampling.jl

Julia implementation of elliptical slice sampling.

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.com/devmotion/EllipticalSliceSampling.jl.svg?branch=master)](https://travis-ci.com/devmotion/EllipticalSliceSampling.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/devmotion/EllipticalSliceSampling.jl?svg=true)](https://ci.appveyor.com/project/devmotion/EllipticalSliceSampling-jl)
[![Codecov](https://codecov.io/gh/devmotion/EllipticalSliceSampling.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/devmotion/EllipticalSliceSampling.jl)
[![Coveralls](https://coveralls.io/repos/github/devmotion/EllipticalSliceSampling.jl/badge.svg?branch=master)](https://coveralls.io/github/devmotion/EllipticalSliceSampling.jl?branch=master)

## Overview

This package implements elliptical slice sampling in the Julia language, as described in
[Murray, Adams & MacKay (2010)](http://proceedings.mlr.press/v9/murray10a/murray10a.pdf).

Elliptical slice sampling is a "Markov chain Monte Carlo algorithm for performing
inference in models with multivariate Gaussian priors" (Murray, Adams & MacKay (2010)).

Without loss of generality, the originally described algorithm assumes that the Gaussian
prior has zero mean. For convenience we allow the user to specify arbitrary Gaussian
priors with non-zero means and handle the change of variables internally.

## Usage

Probably most users would like to use the exported function
```julia
ESS_mcmc([rng::AbstracRNG,] prior, loglikelihood, N::Int[; burnin::Int = 0])
```
which returns a Markov chain of `N` samples for approximating the posterior of
a model with a multivariate Gaussian prior that allows sampling from the `prior`
and evaluation of the log likelihood `loglikelihood`. The burn-in phase with
`burnin` samples is discarded.

If you use a package such as [Juno](https://junolab.org/) or
[ConsoleProgressMonitor.jl](https://github.com/tkf/ConsoleProgressMonitor.jl) that supports
progress logs created by the
[ProgressLogging.jl](https://github.com/JunoLab/ProgressLogging.jl) API, then you can
monitor the progress of the sampling algorithm.

## Bibliography

Murray, I., Adams, R. & MacKay, D.. (2010). Elliptical slice sampling. Proceedings of Machine Learning Research, 9:541-548.
