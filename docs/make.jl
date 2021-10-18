using Documenter
using EllipticalSliceSampling

makedocs(;
    sitename="EllipticalSliceSampling",
    format=Documenter.HTML(),
    modules=[EllipticalSliceSampling],
    pages=["Home" => "index.md"],
    strict=true,
    checkdocs=:exports,
)

deploydocs(; repo="github.com/TuringLang/EllipticalSliceSampling.jl.git", devbranch="main", push_preview=true)
