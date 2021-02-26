using Pkg
pkg"activate ."
pkg"instantiate"
include(joinpath(@__DIR__, "..", "src", "ReplitDatabase.jl"))
using .ReplitDatabase