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
--                                     Getters and Setters
---------------------------------------------------------------------------------------------

-- returns object under the mouse
--@return mouseover userdata - userdata of object under the mouse          
function GetMouseover()
    local mouseover = Ext.UI.GetPickingHelper(1)
    if mouseover ~= nil then
        return mouseover
    else
        _P("No mouseover")
    end 
end


-- returns entity uuid from userdata
--@param mouseover userdata 
function getUUIDFromUserdata(mouseover)
    local entity = mouseover.Inner.Inner[1].GameObject
    if entity ~= nil then
        return Ext.Entity.HandleToUuid(entity)
    else
        _P("Not an entity")
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
function deepCopy(orig)
    local copy = {}

    success, iterator = pcall(pairs, orig)
    if success == true and (type(orig) == "table" or type(orig) == "userdata") then

        for label, content in pairs(orig) do

            if content then
                 copy[deepCopy(tostring(label))] = deepCopy(content)
            else
                copy[deepCopy(label)] = "nil"
            end

        end
        if copy and (not #copy == 0) then
            setmetatable(copy, deepCopy(getmetatable(orig)))
        end
    else
        copy = orig
    end
    return copy
end



-- string.find but not case sensitive
--@param str1 string       - string 1 to compare
--@param str2 string  - string 2 to compare
local function CaseInsensitiveSearch(str1, str2)
    str1 = string.lower(str1)
    str2 = string.lower(str2)
    local result = string.find(str1, str2, 1, true)
    return result ~= nil
end
