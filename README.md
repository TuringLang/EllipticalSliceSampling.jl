# EllipticalSliceSampling.jl

Julia implementation of elliptical slice sampling.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://turinglang.github.io/EllipticalSliceSampling.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://turinglang.github.io/EllipticalSliceSampling.jl/dev)
[![Build Status](https://github.com/TuringLang/EllipticalSliceSampling.jl/workflows/CI/badge.svg?branch=main)](https://github.com/TuringLang/EllipticalSliceSampling.jl/actions?query=workflow%3ACI%20branch%3Amain)
[![Codecov](https://codecov.io/gh/TuringLang/EllipticalSliceSampling.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/TuringLang/EllipticalSliceSampling.jl)
[![Coveralls](https://coveralls.io/repos/github/TuringLang/EllipticalSliceSampling.jl/badge.svg?branch=main)](https://coveralls.io/github/TuringLang/EllipticalSliceSampling.jl?branch=main)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

## Overview

This package implements elliptical slice sampling in the Julia language, as described in
[Murray, Adams & MacKay (2010)](http://proceedings.mlr.press/v9/murray10a/murray10a.pdf).

Elliptical slice sampling is a "Markov chain Monte Carlo algorithm for performing
inference in models with multivariate Gaussian priors" (Murray, Adams & MacKay (2010)).

Please check the [documentation](https://turinglang.github.io/EllipticalSliceSampling.jl/stable)
for more details.

## Poster at JuliaCon 2021

[![EllipticalSliceSampling.jl: MCMC with Gaussian priors](http://img.youtube.com/vi/S5gUED7Uq2Q/0.jpg)](https://www.youtube.com/watch?v=S5gUED7Uq2Q)

The slides are available as [Pluto notebook](https://talks.widmann.dev/2021/07/ellipticalslicesampling/).

## References

Murray, I., Adams, R. & MacKay, D.. (2010). Elliptical slice sampling. Proceedings of Machine Learning Research, 9:541-548.
