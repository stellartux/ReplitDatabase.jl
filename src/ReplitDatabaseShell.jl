module ReplitDatabaseCore

export delete!, get, set!, list

"""
    set!(key::AbstractString, value::AbstractString)

Set the given key/value pair in the Repl.it database.
"""
function set!(key::AbstractString, value::AbstractString)
    success(`curl -s $(ENV["REPLIT_DB_URL"]) -d $(key * "=" * value)`)
end

"""
    get(key::AbstractString)

Get the value associated with the given key in the Repl.it database.
"""
function get(key::AbstractString)
    readchomp(`curl -s $(ENV["REPLIT_DB_URL"] * "/" * key)`)
end

"""
    delete!(key::AbstractString)

Deletes the value associated with the given key in the Repl.it database.
"""
function delete!(key::AbstractString)
    success(`curl -s -XDELETE $(ENV["REPLIT_DB_URL"] * "/" * key)`)
end

"""
    list()
    list(prefix::AbstractString)

Lists all of the keys in the Repl.it database, or all of the keys starting with `prefix` if specified.
"""
function list(prefix=""::AbstractString)::Vector{<:AbstractString}
    result = readchomp(`curl -s "$(ENV["REPLIT_DB_URL"])?prefix=$(prefix)"`)
    isempty(result) ? String[] : split(result, '\n')
end

end # module
