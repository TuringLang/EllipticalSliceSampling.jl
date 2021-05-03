module EllipticalSliceSampling

using AbstractMCMC: AbstractMCMC
using ArrayInterface: ArrayInterface
using Distributions: Distributions

using Random: Random
using Statistics: Statistics

export ESSModel, ESS

# reexports
using AbstractMCMC: sample, MCMCThreads, MCMCDistributed
export sample, MCMCThreads, MCMCDistributed

include("abstractmcmc.jl")
include("model.jl")
include("interface.jl")

end # module
