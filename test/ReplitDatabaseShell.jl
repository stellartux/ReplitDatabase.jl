using Test

include(joinpath(@__DIR__, "..", "src", "ReplitDatabaseShell.jl"))

@testset "Testing CRUD commands" begin
    results = ReplitDatabaseCore.list()
    @test results == []
    
    ReplitDatabaseCore.set!("hello", "world")
    results = ReplitDatabaseCore.list()
    @test results == ["hello"]

    @test ReplitDatabaseCore.get(results[1]) == "world"

    ReplitDatabaseCore.delete!(results[1])
    @test ReplitDatabaseCore.list() == []
end
