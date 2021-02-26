# ReplitDatabase.jl

[![Run on Repl.it](https://repl.it/badge/github/stellartux/ReplitDatabase.jl)](https://repl.it/github/stellartux/ReplitDatabase.jl)

A Julia interface to the [repl.it](https://repl.it/) [database](https://docs.repl.it/misc/database).

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/stellartux/ReplitDatabase.jl")
```

## Use

```julia
julia> using ReplitDatabase

julia> db # an AbstractDict{String,String} representing the database
ReplitDB()

julia> db["foo"] = "bar" # set "foo"=>"bar" in the database
"bar"

julia> db["baz"] = "qux" # set "baz"=>"qux" in the database
"qux"

julia> db["foo"] # gets the value associated with the key "foo" from the database
"bar" 

julia> keys(db) # get the keys of the database
2-element Array{String,1}:
 "baz"
 "foo"

julia> keys(db, "f") # get the keys filtered by a prefix
1-element Array{String,1}:
 "foo"

julia> db["baz"] = nothing # delete a value from the database

julia> copy!(db, Dict("hello" => "world")) # overwrite the database with a Dict{String,String}
ReplitDB()

julia> empty!(db) # clear the database
```
