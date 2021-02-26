if "REPLIT_DB_URL" in ENV
    include(joinpath(@__DIR__, "ReplitDatabaseShell.jl"))
end
