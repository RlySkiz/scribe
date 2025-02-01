-- extensions of basic things, lua stdlib smh

---Quick split
---@param self string
---@param delimiter string
---@return table<string>
function string:split(delimiter)
    local result = {}
    local from  = 1
    local delim_from, delim_to = string.find(self, delimiter, from)
    while delim_from do
        table.insert( result, string.sub(self, from , delim_from-1))
        from  = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end
    table.insert( result, string.sub(self, from))
    return result
end

---@param table table
---@param element any
---@return boolean
function table.contains(table, element)
    if type(table) ~= "table" then
        return false
    end

    if table == nil or element == nil then
        return false
    end

    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

---@param table table
---@param element any
---@return integer|nil index
function table.indexOf(table, element)
    for index, value in ipairs(table) do
        if value == element then
            return index
        end
    end
    return nil
end

function table.isEmpty(tbl)
    if not tbl then return true end
    return next(tbl) == nil
end
function table.count(tbl)
    if not tbl then return 0 end
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end


---Associative table pairs iterator, returns values sorted based on keys; optional boolean to specify descending order
---Eg. for key, v in table.pairsByKeys(someTable) do
---@param t table
---@param f boolean|function|nil optional descendingOrder boolean OR sorting function
---@return function iterator 
function table.pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    if type(f) == "boolean" then
        if f then
            table.sort(a, function(b,c) return b > c end)
        else
            table.sort(a)
        end
    else
        table.sort(a, f)
    end
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

-- Attempt at alphanumeric sorting, based on https://stackoverflow.com/a/27911647
function table.pairsByKeysNumerically(t, desc) -- FIXME this even work?
    return table.pairsByKeys(t, function(a,b)
        a = tostring(a.N)
        b = tostring(b.N)
        local patt = '^(.-)%s*(%d+)$' -- :thonkers:
        local _,_, col1, num1 = a:find(patt)
        local _,_, col2, num2 = b:find(patt)
        if (col1 and col2) and col1 == col2 then
            return tonumber(num1) < tonumber(num2)
        end
        return desc and a < b or a > b
    end)
end