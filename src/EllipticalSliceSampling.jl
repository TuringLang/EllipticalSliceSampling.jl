module EllipticalSliceSampling

using ArrayInterface
using Distributions
using Parameters
using ProgressLogging

using Random

export ESS_mcmc, ESS_mcmc_sampler

include("utils.jl")
include("types.jl")
include("iterator.jl")
include("interface.jl")

end # module
