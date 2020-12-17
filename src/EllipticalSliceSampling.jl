module EllipticalSliceSampling

import AbstractMCMC
import ArrayInterface
import Distributions

import Random
import Statistics

export ESSModel, ESS

# reexports
using AbstractMCMC: sample, MCMCThreads, MCMCDistributed
export sample, MCMCThreads, MCMCDistributed

include("abstractmcmc.jl")
include("model.jl")
include("interface.jl")

end # module
