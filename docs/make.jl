using ManualMemory
using Documenter

DocMeta.setdocmeta!(ManualMemory, :DocTestSetup, :(using ManualMemory); recursive=true)

makedocs(;
    modules=[ManualMemory],
    authors="chriselrod <elrodc@gmail.com> and contributors",
    repo="https://github.com/JuliaSIMD/ManualMemory.jl/blob/{commit}{path}#{line}",
    sitename="ManualMemory.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaSIMD.github.io/ManualMemory.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaSIMD/ManualMemory.jl",
    devbranch="main",
)
