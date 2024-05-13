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

local originalDump = {}

function GetOriginalDump()
    return originalDump
end

local function setOriginalDump(value)
    originalDump = value
end

function PopulateTree(tree, currentTable)
    success, iterator = pcall(pairs, currentTable)
    if success == true and (type(currentTable) == "table" or type(currentTable) == "userdata") then
        for label,content in pairs(currentTable) do
                if content then
                    local newTree = tree:AddTree(tostring(label))
                    PopulateTree(newTree, content)
                else
                    local newTree = tree:AddTree(tostring(label))
                    newTree.Bullet = true
                end
        end
    else
        local newTree = tree:AddTree(tostring(currentTable))
        newTree.Bullet = true
    end
end

local rootRow
local rootCell
local rootTree

function returnInitRootRow()
    return initRootRow
end

function returnInitRootCell()
    return initRootCell
end

function returnInitRootTree()
    return initRootTree
end

local function setInitRootRow(row)
    initRootRow = row
end

local function setInitRootCell(cell)
    initRootCell = cell
end

local function setInitRootTree(tree)
    initRootTree = tree
end

local mouseoverDumpTree

function returnMouseoverDumpTree()
    return mouseoverDumpTree
end

doOnce = 0
-- initializes a tab with all components as trees and subtrees
--@param tab TabItem - name of the tab that the components will be displayed under
function InitializeTree(tab)
    local dump
    local rowToPopulate

    -- Decide what to do for each tab
    if tab.Label == "Mouseover" then
        dump = getMouseover()
        rowToPopulate = mouseoverTableRow
    elseif tab.Label == "Entity" then
        dump = Ext.Entity.Get(getEntityUUID()):GetAllComponents()
        rowToPopulate = entityTableRow
    elseif tab.Label == "VisualBank" then
        Ext.Net.PostMessageToServer("RequestCharacterVisual", getEntityUUID())
        dump = GetCharacterVisual()
        rowToPopulate = visualTableRow
    end
        
    -- Get initial root for deletion of previous dump
    local initRootRow = returnInitRootRow()
    local initRootCell = returnInitRootCell()
    local initRootTree = returnInitRootTree()

    -- Destroy previous dump if it exist, else create new initial one
    if initRootTree then
        -- Remove leftover tree
        initRootCell:RemoveChild(initRootTree.Handle)
        -- Create new tree
        local rootTree = initRootCell:AddTree(tab.Label)
        setInitRootTree(rootTree)
        PopulateTree(rootTree, dump)
    else
        -- Get row, then create cell/tree and populate it, also serialize the dump
        local rootRow = rowToPopulate
        local rootCell = rootRow:AddCell()
        local rootTree = rootCell:AddTree(tab.Label)
        setInitRootRow(rootRow)
        setInitRootCell(rootCell)
        setInitRootTree(rootTree)
        PopulateTree(rootTree, dump)
        setOriginalDump(serializeDump(dump))
    end
    
    if doOnce == 0 then
    -- Create dump info sidebar
        mouseoverDumpInfo = mouseoverTableRow:AddCell():AddText("Test")
        doOnce = doOnce+1
    end
    mouseoverDumpInfo.Label = Ext.DumpExport(getMouseover())
    
    ---- TODO fix this
    -- if tab    
    -- else
    --     print(tab ," is not a recognized tab") 
    -- end
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

-- function serializeMouseoverDump(mouseover)
--     local serializedMouseover = {}
--     -- _P(mouseover)
--     -- _D(mouseover)
--     for key, value in pairs(mouseover) do
--         -- Only copy the data you need, and ensure it's in a Lua-friendly format
--         local entry = {key, value}
--         table.insert(serializedMouseover, entry)
--     end
--     -- _D(serializedMouseover)
--     return serializedMouseover
-- end

function serializeDump(dump)
    local serializedDump = {}

    success, iterator = pcall(pairs, dump)
    if success == true and (type(dump) == "table" or type(dump) == "userdata") then
        for label,content in pairs(dump) do
            if content then
                local entry = {label, content}
                table.insert(serializedDump, entry)
            else
                local entry = {label, nil}
                table.insert(serializedDump, entry)
            end

            local entry = {label, nil}
            table.insert(serializedDump, entry)
        end
        _D(serializedDump)
        return serializedDump
    end
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