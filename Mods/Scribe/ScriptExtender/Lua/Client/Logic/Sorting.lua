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




local function caseInsensitiveSearch(input, searchTerm)
    
    -- Convert both strings to lower case to ensure the search is case-insensitive
    input = string.lower(input)
    searchTerm = string.lower(searchTerm)
    -- Use string.find with the 'plain' option set to true to avoid pattern matching
    local result = string.find(input, searchTerm, 1, true)

    if result then
        _P("--------------------------------------")
        _P("Comparing ", input , " and ", searchTerm)
        _P("match? ", result)
        _P("--------------------------------------")
    end
    return result ~= nil
end


-- Removes a value from a key,value type table
local function deleteValue(tbl, valueToRemove)
    for key, value in pairs(tbl) do
        if value == valueToRemove then
            tbl[key] = nil
        end
    end
end



-- Recursively filters a table based on a search term
--@param searchTerm string         - the searchTerm by what to filter
--@param tableToFilter table       - the original table
--@return table                    - returns a new table containing only the elements that include the search term
function Sorting:filter(searchTerm, tableToFilter)
    local foundInKey = false
    local filteredTable = {}

    if type(tableToFilter) == "table" then
        for key, value in pairs(tableToFilter) do
            local foundInKey = false
            _P("Key ", key, " value ", value)

            -- Check for search term in the key
            if caseInsensitiveSearch(tostring(key), searchTerm) then
                print("found ", searchTerm, " in key ", key)
                foundInKey = true
                _P("found value in key")
            end

            -- Continue processing only if the key search was not successful
            if (type(value) == "table") and (not foundInKey) then
                -- Recursively filter subtables
                local result = Sorting:filter(searchTerm, value)
                if next(result) ~= nil then
                    filteredTable[key] = result
                end
            elseif not foundInKey then
                -- Check the value if it's not a table
                if caseInsensitiveSearch(tostring(value), searchTerm) then
                    filteredTable[key] = value
                end
            -- found value in key, keep all
            else
                filteredTable[key] = value
            end

        end
    else
        -- Non-table values, compare directly
        if caseInsensitiveSearch(tostring(tableToFilter), searchTerm) then
            return tableToFilter
        end
    end

    return filteredTable
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
        "Freeze",
        "firetest"
    }
}






-- When search field exists, call these functions on key pressed


local function onKeyPressed()

    local content = GetDumpMouseoverLabel()
    --TODO    local searchTerm = ""

    local newContent = Sorting:filter(searchTerm,content)

end



-- returns a tree element that matches the label name of the searchTerm
--@param searchTerm string - searchTerm to search
--@param tree ExtuiTree    - Tree to search
--@return tree             - Tree (child) whose label matches search term
function Sorting:find(searchTerm, tree)

end

local dumpy = {
    ActionResources = {
        Resources = {
            ["420c8df5-45c2-4253-93c2-7ec44e127930"] = {
                {
                    Amount = 1.0,
                    MaxAmount = 1.0,
                    ResourceId = 0,
                    ResourceUUID = "420c8df5-45c2-4253-93c2-7ec44e127930",
                    SubAmounts = nil,
                    field_28 = 3342631241410948610,
                    field_30 = 0
                }
            },
            ["45ff0f48-b210-4024-972f-b64a44dc6985"] = {
                {
                    Amount = 1.0,
                    MaxAmount = 1.0,
                    ResourceId = 0,
                    ResourceUUID = "45ff0f48-b210-4024-972f-b64a44dc6985",
                    SubAmounts = nil,
                    field_28 = 2140718418690,
                    field_30 = 0
                }
            },
            ["46d3d228-04e0-4a43-9a2e-78137e858c14"] = {
                {
                    Amount = 2.0,
                    MaxAmount = 2.0,
                    ResourceId = 0,
                    ResourceUUID = "46d3d228-04e0-4a43-9a2e-78137e858c14",
                    SubAmounts = nil,
                    field_28 = 2140689990160,
                    field_30 = 0
                }
            },
            ["734cbcfb-8922-4b6d-8330-b2a7e4c14b6a"] = {
                {
                    Amount = 1.0,
                    MaxAmount = 1.0,
                    ResourceId = 0,
                    ResourceUUID = "734cbcfb-8922-4b6d-8330-b2a7e4c14b6a",
                    SubAmounts = nil,
                    field_28 = 2140668823810,
                    field_30 = 0
                }
            },
            ["969e03bd-7f4b-4737-9ea7-002726faea95"] = {
                {
                    Amount = 4.0,
                    MaxAmount = 4.0,
                    ResourceId = 0,
                    ResourceUUID = "969e03bd-7f4b-4737-9ea7-002726faea95",
                    SubAmounts = nil,
                    field_28 = 2140684682760,
                    field_30 = 0
                }
            },
        }
    }
}

-- _P("SORTING TEST")
-- _D(filter("fire", spells))
-- _P("dumpy")
-- _D(filter("Visual", Ext.Entity.Get(getEntityUUID()):GetAllComponents()))