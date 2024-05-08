-------------------------------------------------------------------------------------------------------
-- 
-- 	                                    Tabel Sorting
--
-- 
---------------------------------------------------------------------------------------------------------



Sorting = {}
Sorting.__index = Sorting

function Sorting:new()
    local instance = setmetatable({}, Sorting)
    return instance
end



-- Function to perform a case-insensitive search
--@param value string - the string to search within
--@param searchTerm string - the search term to look for
--@return boolean - true if the searchTerm is found in value (case-insensitive), false otherwise
local function caseInsensitiveSearch(value, searchTerm)

    local lowerValue = string.lower(value)
    local lowerSearchTerm = string.lower(searchTerm)

    return string.find(lowerValue, lowerSearchTerm) ~= nil
end



-- Filters a table based on a search Term by calling a recursive function - subtables are preserved
--@param searchTerm string         - the searchTerm by what to filter
--@param tableToFilter table       - the original table
--return filteredTable table	   - the filtered table
local function filter(searchTerm, tableToFilter)

    _P("Called filter on table ", tableToFilter, " with size ", #tableToFilter)

    for i = #tableToFilter, 1, -1 do

        print("Checking index ", i , " ", tableToFilter[i])

        -- if the search term is not found in the parent, only keep it if its found in the children

        if not caseInsensitiveSearch(tableToFilter[i], searchTerm) then
            print(tableToFilter[i], " does not contain ", searchTerm)

            -- recursively call function on children
            -- if false is returned then parent node can be yeeted
            local contains = Sorting:filter(searchTerm, tableToFilter)

            if not contains then
                print("Children don't contain search termn. Yeeting parent")
                table.remove(tableToFilter, i)
            else
                print("Children contain search term. Keeping parent")
            end

        else
            print(tableToFilter[i], " contains ", searchTerm, " skipping removal")

        end

    end

    return tableToFilter 
    
end



-- Filters a table based on a search Term recursively - subtables are preserved
--@param searchTerm string         - the searchTerm by what to filter
--@param tableToFilter table       - the original table
--return contains bool             - returns true if the search term is contained, else returns false
local function filterRecurse(searchTerm, tableToFilter)

    if type(tableToFilter) == "table" then 

        for i = #tableToFilter, 1, -1 do
            print("Checking index ", i , " ", tableToFilter[i])

            -- if the search term is not found in the parent, only keep it if its found in the children

            if not caseInsensitiveSearch(tableToFilter[i], searchTerm) then
                print(tableToFilter[i], " does not contain ", searchTerm)

                -- recursively call function on children
                -- if false is returned then parent node can be yeeted
                Sorting:filter(searchTerm, tableToFilter)





            else
                print(tableToFilter[i], " contains ", searchTerm, " skipping removal")

            end

        end



    else
        print(tableToFilter, " is not a table")


    end


    return tableToFilter 
    
end




-- testing


-- Testing

local spells = {
    ["fire"] = {
        "Fireball",
        "Flame Strike",
        "Wall of Fire"
    },
    ["ice"] = {
        "Ice Storm",
        "Cone of Cold",
        "Freeze"
    }
}

_D(filter("fire", spells))







-- When search field exists, call these functions on key pressed




local function onKeyPressed()

    local content = GetDumpMouseoverLabel()
    --TODO    local searchTerm = ""

    local newContent = Sorting:filter(searchTerm,content)


end
