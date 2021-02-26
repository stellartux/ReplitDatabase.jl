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
using ReplitDatabase

# an AbstractDict{String,String} representing the database
db = ReplitDB()

# set the key "foo" to value "bar" in the database
db["foo"] = "bar"

# gets the value associated with the key "foo" from the database
db["foo"] # == "bar" 

# get the keys of the database
keys(db) # == "foo"

# overwrite the database with a Dict{String,String}
copy!(db, Dict("hello" => "world")) 

# clear the database
empty!(db)
```
