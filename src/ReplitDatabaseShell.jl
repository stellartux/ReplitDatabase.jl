"""
    ReplitDatabaseCore

The core functions which access the database.
This implementation accessing the database using `curl` via shell calls.
The `ReplitDB` interface type depends on these functions.
"""
module ReplitDatabaseCore

"""
    delete!(key::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])

Deletes the value associated with the given key in the Repl.it database.
"""
function delete!(key::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])
    success(`curl -s -XDELETE $(url * "/" * key)`)
end

"""
    get(key::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])

Get the value associated with the given key in the Repl.it database.
"""
function get(key::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])
    readchomp(`curl -s $(url * "/" * key)`)
end

"""
    list(; url::AbstractString=ENV["REPLIT_DB_URL"])
    list(prefix::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])

Lists all of the keys in the Repl.it database, or all of the keys starting with `prefix` if specified.
"""
function list(prefix=""::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])::Vector{<:AbstractString}
    result = readchomp(`curl -s "$(url)?prefix=$(prefix)"`)
    isempty(result) ? String[] : split(result, '\n')
end

"""
    set!(key::AbstractString, value::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])

Set the given key/value pair in the Repl.it database.
"""
function set!(key::AbstractString, value::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])
    success(`curl -s $(url) -d $(key * "=" * value)`)
end

end # module
