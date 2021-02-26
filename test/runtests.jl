using Test
include(joinpath(@__DIR__, "..", "src", "ReplitDatabase.jl"))
using .ReplitDatabase

if "REPLIT_DB_URL" in keys(ENV)
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

    @testset "AbstractDict interface" begin
        db = ReplitDB()
        db["key"] = "value"
        @test ReplitDatabaseCore.get("key") == db["key"]

        empty!(db)
        @test length(keys(db)) == 0
    end

    @testset "Key with line breaks" begin
        db["a\nkey\nwith\nline\nbreaks"] = "why\nwould\nyou\ndo\nthis?"
        @test keys(db) == ["a\nkey\nwith\nline\nbreaks"]
        @test db["a\nkey\nwith\nline\nbreaks"] == "why\nwould\nyou\ndo\nthis?"
        empty!(db)
    end
else
    @warn "Could not find \"REPLIT_DB_URL\" in the environment, ReplitDatabaseCore tests won't be run."
end
