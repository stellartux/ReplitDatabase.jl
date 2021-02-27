"""
    ReplitDatabaseCore

The core functions which access the database.
This implementation accesses the database using `curl` via shell calls.
The `ReplitDB` interface type depends on these functions.

## Exports

- `get(key; url)`
- `set!(key, value; url)`
- `list([prefix]; url)`
- `delete!(key; url)`
"""
module ReplitDatabaseCore
export delete!, get, list, set!

using HTTP
using URIs: escapeuri, unescapeuri

"""
    delete!(key::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])

Deletes the value associated with the given key in the Repl.it database.
"""
function delete!(key::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])
    HTTP.request("DELETE", "$(url)/$(escapeuri(key))")
end

"""
    get(key::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])

Get the value associated with the given key in the Repl.it database.
"""
function get(key::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])
    try 
        String(HTTP.get("$(url)/$(escapeuri(key))").body)
    catch err
        if err.status == 404
            throw(KeyError(key))
        else
            throw(err)
        end
    end 
end

"""
    list(; url::AbstractString=ENV["REPLIT_DB_URL"])
    list(prefix::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])

Lists all of the keys in the Repl.it database, or all of the keys starting with `prefix` if specified.
"""
function list(prefix=""::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])::Vector{String}
    escapedurl = "$(url)?prefix=$(escapeuri(prefix))&encode=true"
    result = String(HTTP.get(escapedurl).body)
    isempty(result) ? String[] : unescapeuri.(split(result, '\n'))    
end

"""
    set!(key::AbstractString, value::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])

Set the given key/value pair in the Repl.it database.
"""
function set!(key::AbstractString, value::AbstractString; url::AbstractString=ENV["REPLIT_DB_URL"])
    # success(`curl -s $(url) -d $(key * "=" * value)`)
    try
        response = HTTP.post(url, ["Content-Type" => "application/x-www-form-urlencoded"], "$(key)=$(value)")
    catch response
    finally
        response.status == 200
    end
end

end # module
