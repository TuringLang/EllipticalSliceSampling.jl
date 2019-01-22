using Documenter, EllipticalSliceSampling

makedocs(;
    modules=[EllipticalSliceSampling],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/devmotion/EllipticalSliceSampling.jl/blob/{commit}{path}#L{line}",
    sitename="EllipticalSliceSampling.jl",
    authors="David Widmann",
    assets=[],
)

deploydocs(;
    repo="github.com/devmotion/EllipticalSliceSampling.jl",
)
