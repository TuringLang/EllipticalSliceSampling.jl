using SafeTestsets
using TerminalLoggers: TerminalLogger

using Logging: global_logger

global_logger(TerminalLogger())

@safetestset "Simple tests" begin include("simple.jl") end
@safetestset "GP regression tests" begin include("regression.jl") end
