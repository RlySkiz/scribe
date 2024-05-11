function getMouseover()
    local mouseover = Ext.UI.GetPickingHelper(1)
    if mouseover ~= nil then
        return mouseover
    else
        _P("No mouseover")
    end 
end

function getEntityUUID()
    local entity = Ext.UI.GetPickingHelper(1).Inner.Inner[1].GameObject
    if entity ~= nil then
        return Ext.Entity.HandleToUuid(entity)
    else
        _P("Not an entity")
    end
end


function PopulateTree(tree, currentTable)
    success, iterator = pcall(pairs, currentTable)
    if success == true and (type(currentTable) == "table" or type(currentTable) == "userdata") then
        for label,content in pairs(currentTable) do
                if content then
                    local newTree = tree:AddTree(tostring(label))
                    -- _P(newTree.Handle, " gets attached to: ", newTree.Parent)
                    -- tree:AttachChild(newTree.Parent, newTree.Handle)
                    PopulateTree(newTree, content)
                else
                    local newTree = tree:AddTree(tostring(label))
                    -- _P(newTree.Handle, " gets attached to: ", newTree.Parent)
                    -- tree:AttachChild(newTree.Parent, newTree.Handle)
                    newTree.Bullet = true
                end
        end
    else
        local newTree = tree:AddTree(tostring(currentTable))
        -- _P(newTree.Handle, " gets attached to: ", newTree.Parent)
        -- tree:AttachChild(newTree.Parent, newTree.Handle)
        newTree.Bullet = true
    end
end

-- initializes a tab with all components as trees and subtrees
--@param tab TabItem - name of the tab that the components will be displayed under
function InitializeTab(tab)

    if tab.Label == "Mouseover" then
        local mouseover = getMouseover()
        PopulateTree(mouseoverDumpTree,mouseover)

        elseif tab.Label == "Entity" then
            local entity = Ext.Entity.Get(getEntityUUID()):GetAllComponents()
            PopulateTree(entityDumpTree,entity)
        elseif tab.Label == "VisualBank" then
            Ext.Net.PostMessageToServer("RequestCharacterVisual", getEntityUUID())
            local visual = GetCharacterVisual()
            _P(visual) -- TODO is nil because client doesn't wait for server to receive message
    else
        print(tab ," is not a recognized tab")
    end
end







--initializeTab(mouseoverTab)
--initializeTab(entityTab)
-- initializeTab(visualTab)




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



 -- get Slots (contain body, hair, gloves, tails etc.)
 -- serialize them because else they expire
 -- @param           - uuid of the NPC
 ---return           - Slots (Table)

 function serializeMouseoverDump(mouseover)
    local serializedMouseover = {}
    _P(mouseover)
    _D(mouseover)
    for key, value in pairs(mouseover) do
        -- Only copy the data you need, and ensure it's in a Lua-friendly format
        local entry = {key, value}
        table.insert(serializedMouseover, entry)
    end
    _D(serializedMouseover)
    return serializedMouseover
end


 -- save Slots (contain body, hair, gloves, tails etc.)
 -- @param           - uuid of the NPC
 ---return           - Slots (Table)
function saveVisualSet_Slots(uuid)
    local slots = serializeVisualSetSlots(uuid)
    local entry = {uuid = uuid, slots = slots}
    table.insert(OriginalTemplates, entry)
    _D(slots)
end