using Documenter
using EllipticalSliceSampling

makedocs(;
    sitename="EllipticalSliceSampling",
    format=Documenter.HTML(),
    modules=[EllipticalSliceSampling],
    pages=["Home" => "index.md"],
    checkdocs=:exports,
)
