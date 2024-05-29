--------------------------------------------------------------------------------------
--
--
--                                      USEFUL FUNCTIONS
--                 
--
---------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
--                                      CONSTANTS
---------------------------------------------------------------------------------------------

-- Options for stringifying
STRINGIFY_OPTIONS = {
    StringifyInternalTypes = true,
    IterateUserdata = true,
    AvoidRecursion = true
    }


--------------------------------------------------------------------------------------------
--                                     Variables
--------------------------------------------------------------------------------------------

-- TODO - this doesn't belong here -> move to a mouseover related class
local savedMouseover


--------------------------------------------------------------------------------------------
--                                     Getters and Setters
----------------------------

-----------------------------------------------------------------


-- TODO - this doesn't belong here -> move to a mouseover related class
-- returns object under the mouse
--@return mouseover userdata - userdata of object under the mouse          
function GetMouseover()
    local mouseover = Ext.UI.GetPickingHelper(1)
    if mouseover ~= nil then
    -- setSavedMouseover(mouseover)
        return mouseover
    else
        _P("[Utils.lua] - GetMouseover - No mouseover!")
    end 
end


-- TODO - this doesn't belong here -> move to a mouseover related class
function GetSavedMouseover()
return savedMouseover
end


-- returns entity uuid from userdata
--@param mouseover userdata 
--@return uuid     string
function getUUIDFromUserdata(mouseover)
    local entity = mouseover.Inner.Inner[1].GameObject
    if entity ~= nil then
        return Ext.Entity.HandleToUuid(entity)
    else
        _P("[Utils.lua] - getUUIDFromUserdata(mouseover) - Not an entity!")
    end
end



--------------------------------------------------------------------------------------------
--                                     Methods
---------------------------------------------------------------------------------------------

--- Retrieves the value of a specified property from an object or returns a default value if the property doesn't exist.
-- @param obj           The object from which to retrieve the property value.
-- @param propertyName  The name of the property to retrieve.
-- @param defaultValue  The default value to return if the property is not found.
-- @return              The value of the property if found; otherwise, the default value.
function GetPropertyOrDefault(obj, propertyName, defaultValue)
    local success, value = pcall(function() return obj[propertyName] end)
    if success then
        return value or defaultValue
    else
        return defaultValue
    end
end


-- Measures the true size of a table, considering both sequential and non-sequential keys
-- @param table table    -       table to count
-- @return int           -       size of the table
function TableSize(table)
    local count = 0
        for _ in pairs(table) do
        count = count + 1
    end
    return count
end


-- Perform a deep copy of a table - necessary when lifetime expires
--@param    orig table - orignial table
--@return   copy table - copied table
function DeepCopy(orig)
local copy = {}

    success, iterator = pcall(pairs, orig)
    if success == true and (type(orig) == "table" or type(orig) == "userdata") then

        for label, content in pairs(orig) do

        if content then
            copy[DeepCopy(tostring(label))] = DeepCopy(content)
        else
            copy[DeepCopy(label)] = "nil"
        end

    end

    if copy and (not #copy == 0) then
        setmetatable(copy, DeepCopy(getmetatable(orig)))
    end

    else
        copy = orig
    end
        return copy
end



-- string.find but not case sensitive
--@param str1 string       - string 1 to compare
--@param str2 string       - string 2 to compare
function CaseInsensitiveSearch(str1, str2)
    str1 = string.lower(str1)
    str2 = string.lower(str2)
    local result = string.find(str1, str2, 1, true)
    return result ~= nil
end



-- TODO: concatenate function (copy from DOLL)
function Concat(tab1, tab2)

end




-- sorts a key, value pair table
function SortData(data)

    if type(data) == "table" or type(data) == "userdata" then
        local array = {}

        for key, value in pairs(data)do
        table.insert(array, {key = key, value = value})
        end

        table.sort(array, function(a, b)
            -- Convert keys to numbers for comparison
            local keyA, keyB = tonumber(a.key), tonumber(b.key)
            -- If conversion is successful, compare numerically
            if keyA and keyB then
                return keyA < keyB
            else
                -- If conversion fails, compare as strings
                return a.key < b.key
            end
        end)

        return array, data
    else
        return data, data
    end
end