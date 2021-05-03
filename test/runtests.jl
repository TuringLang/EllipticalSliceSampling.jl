using EllipticalSliceSampling

using Distances
using Distributions
using FillArrays

using Distributed
using LinearAlgebra
using Random
using Statistics
using Test

Random.seed!(0)

# add additional processes
addprocs(2)
@everywhere begin
    using EllipticalSliceSampling
    using Distributions
end

@testset "EllipticalSliceSampling" begin
    println("Simple tests")
    @testset "Simple tests" begin
        include("simple.jl")
    end

    println("GP regression tests")
    @testset "GP regression tests" begin
        include("regression.jl")
    end
end
