using Test
include(joinpath(@__DIR__, "..", "src", "ReplitDatabase.jl"))
using .ReplitDatabase

if "REPLIT_DB_URL" in keys(ENV)
    @testset "Database is empty" begin
        results = ReplitDatabaseCore.list()
        @test results == []
    end

    @testset "Testing CRUD commands" begin        
        ReplitDatabaseCore.set!("hello", "world")
        results = ReplitDatabaseCore.list()
        @test results == ["hello"]

        @test ReplitDatabaseCore.get(results[1]) == "world"

        ReplitDatabaseCore.delete!(results[1])
        @test ReplitDatabaseCore.list() == []
    end

    @testset "AbstractDict interface" begin
        db["key"] = "value"
        @test ReplitDatabaseCore.get("key") == db["key"]
        db["key"] = nothing

        @test length(keys(db)) == 0
        @test isempty(db)
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
