using SafeTestsets

@safetestset "Simple tests" begin include("simple.jl") end
@safetestset "GP regression tests" begin include("regression.jl") end
