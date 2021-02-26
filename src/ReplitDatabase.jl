"""
    ReplitDatabase

The `ReplitDatabase` module allows for easy access to the Repl.it database.

## Exports

- `ReplitDB` - an `AbstractDict{String,String}` interface to the Repl.it database.
- `ReplitDatabaseCore` - the core functions which `ReplitDB` uses to communicate with the database.
  - `get(key; url)`
  - `set!(key, value; url)`
  - `list([prefix]; url)`
  - `delete!(key; url)`
"""
module ReplitDatabase
export ReplitDB, ReplitDatabaseCore

include(joinpath(@__DIR__, "ReplitDatabaseShell.jl"))

struct ReplitDB <: AbstractDict{String,String}
    url::String
end

"""
    ReplitDB(url = ENV["REPLIT_DB_URL"])

An `AbstractDict{String,String}` interface representing the Repl.it database.

## Examples

```julia
julia> db = ReplitDB()
ReplitDB()

julia> db["foo"] = "bar"
"bar"

julia> db["hello"] = "world"
"bar"

julia> collect(keys(db))
2-element Array{String,1}:
 "foo"
 "hello"

julia> collect(keys(db, "fo"))
1-element Array{String,1}:
 "foo"

julia> delete!(db, "foo")
ReplitDB()

julia> isempty(db)
false

julia> empty!(db)
ReplitDB()

julia> isempty(db)
true
```
"""
function ReplitDB()
    if haskey(ENV, "REPLIT_DB_URL")
        ReplitDB(ENV["REPLIT_DB_URL"])
    else
        throw(ArgumentError("Could not find the ReplitDB URL in the environment"))
    end
end

function Base.delete!(db::ReplitDB, key::AbstractString)
    if haskey(db, key)
        ReplitDatabaseCore.delete!(key, url=db.url)
        db
    else
        throw(KeyError(key))
    end
end

Base.eltype(::ReplitDB) = Pair{String,String}

function Base.empty!(db::ReplitDB)
    for key in keys(db)
        delete!(db, key)
    end
    db
end

Base.get(db::ReplitDB, key::AbstractString, default) = get(() -> default, db, key)

Base.get(default::Function, db::ReplitDB, key::AbstractString) = haskey(db, key) ? ReplitDatabaseCore.get(key, url=db.url) : default()

Base.getkey(db::ReplitDB, key::AbstractString, default) = haskey(db, key) ? key : default

Base.haskey(db::ReplitDB, key::AbstractString) = key in ReplitDatabaseCore.list(key, url=db.url)

function Base.iterate(db::ReplitDB, state=keys(db))
    if !isempty(state)
        key, rest = Iterators.peel(state)
        (key => db[key], rest)
    end
end

Base.isempty(db::ReplitDB) = isempty(keys(db))

Base.IteratorEltype(::ReplitDB) = Base.HasEltype()

Base.IteratorSize(::ReplitDB) = Base.SizeUnknown()

Base.keys(db::ReplitDB, prefix::AbstractString="") = ReplitDatabaseCore.list(prefix, url=db.url)

Base.length(db::ReplitDB) = length(keys(db))

function Base.pop!(db::ReplitDB, key::AbstractString)
    value = get(db, key) do
        throw(KeyError(key))
    end
    delete!(db, key)
    value
end

function Base.pop!(db::ReplitDB, key::AbstractString, default)
    if haskey(db, key)
        value = get(db, key, nothing)
        delete!(db, key)
        value
    else
        default
    end
end

function Base.setindex!(db::ReplitDB, value::AbstractString, key::AbstractString)
    ReplitDatabaseCore.set!(key, value, url=db.url)
    value
end

Base.setindex(db::ReplitDB, ::Nothing, key::AbstractString) = delete!(db, key)

Base.setindex!(db::ReplitDB, value, key::AbstractString) = db[key] = string(value)

Base.show(io::IO, ::MIME"text/plain", db::ReplitDB) = print(io, "ReplitDB()")

end # module
