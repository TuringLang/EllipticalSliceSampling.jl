module EllipticalSliceSampling

using AbstractMCMC: AbstractMCMC
using ArrayInterface: ArrayInterface
using Distributions: Distributions

using Random: Random
using Statistics: Statistics

export ESSModel, ESS

# reexports
using AbstractMCMC: sample, MCMCThreads, MCMCDistributed, MCMCSerial
export sample, MCMCThreads, MCMCDistributed, MCMCSerial

include("abstractmcmc.jl")
include("model.jl")
include("interface.jl")

end # module
