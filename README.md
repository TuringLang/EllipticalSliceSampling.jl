# EllipticalSliceSampling

Julia implementation of elliptical slice sampling.

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://devmotion.github.io/EllipticalSliceSampling.jl/stable)
[![Latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://devmotion.github.io/EllipticalSliceSampling.jl/latest)
[![Build Status](https://travis-ci.com/devmotion/EllipticalSliceSampling.jl.svg?branch=master)](https://travis-ci.com/devmotion/EllipticalSliceSampling.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/devmotion/EllipticalSliceSampling.jl?svg=true)](https://ci.appveyor.com/project/devmotion/EllipticalSliceSampling-jl)
[![Codecov](https://codecov.io/gh/devmotion/EllipticalSliceSampling.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/devmotion/EllipticalSliceSampling.jl)
[![Coveralls](https://coveralls.io/repos/github/devmotion/EllipticalSliceSampling.jl/badge.svg?branch=master)](https://coveralls.io/github/devmotion/EllipticalSliceSampling.jl?branch=master)

## Overview

This package implements elliptical slice sampling in the Julia language as described in [Murray, Adams & MacKay (2010)](http://proceedings.mlr.press/v9/murray10a/murray10a.pdf).

Elliptical slice sampling is a "Markov chain Monte Carlo algorithm for performing inference in models with multivariate Gaussian priors" (Murray, Adams & MacKay (2010)).

The structure of this package is inspired by [DynamicHMC](https://github.com/tpapp/DynamicHMC.jl), a package for dynamic Hamiltonian Monte Carlo methods.

## Installation

The package is not registered but you can install it with
```julia
]add https://github.com/devmotion/EllipticalSliceSampling.jl
```

## Usage

Probably most users would like to use the exported function
```julia
ESS_mcmc([rng::AbstracRNG,] sampler, ℓ, N::Int)
```
which returns a Markov chain of `N` samples for approximating the posterior of
a model with a multivariate Gaussian prior that allows sampling from the prior
via `sampler` and evaluation of the log likelihood `ℓ`.

## Bibliography

Murray, I., Adams, R. & MacKay, D.. (2010). Elliptical slice sampling. Proceedings of Machine Learning Research, 9:541-548.
