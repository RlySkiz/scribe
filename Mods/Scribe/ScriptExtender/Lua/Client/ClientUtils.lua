-- Options for stringifying
local opts = {
            StringifyInternalTypes = true,
            IterateUserdata = true,
            AvoidRecursion = true
            }

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





-- copied tables
-- key : label name
-- value: table
local copiedTables = {}

-- TODO - better description
-- sets the copied table 
--@param label - label 
--@param dump - values
local function setCopiedTable(label,dump)
    _P("SET COPIED TABLE")
    --_D(label)
    --_D(dump)
    --_D(value)
    copiedTables[label] = dump
    --_D(copiedTables)
end


-- TODO - better description
-- retrieves the copied table
--@param label - label 
--@param dump - values
function GetCopiedTable(label)
    --P("Dump in GetCopiedTable")
    --D(copiedTables)

    if label == "Entity" then
        dump = Ext.Entity.Get(getSavedEntity()):GetAllComponents()
    else
        for key, value in pairs(copiedTables) do
            if key == label then
                return value
            end
        end
    end
    print("[SCRIBE] Error: table doesn't exist")
    return nil    
end

-- local originalDump = {}

-- function GetOriginalDump()
--     return originalDump
-- end

-- local function setOriginalDump(value)
--     originalDump = value
-- end



-- local traversalTree = {}
-- local traversalIndex = 1
function PopulateTree(tree, currentTable, parent)
    success, iterator = pcall(pairs, currentTable)
    if success == true and (type(currentTable) == "table" or type(currentTable) == "userdata") then
        for label,content in pairs(currentTable) do
            if parent == nil or (label == parent) then
                if content then

                    -- special case for empty table
                    local stringify = Ext.Json.Stringify(content, opts)
                    if stringify == "{}" then
                        local newTree = tree:AddTree(tostring(label))
                        -- newTree.IDContext = tostring(tree.Label) .. tostring(traversalIndex)
                        --TODO - check if bullet works here 
                        newTree.Bullet = true
                        -- table.insert(traversalTree, newTree)
                        -- _P("Added ", traversalTree[traversalIndex].Label, " to IDContext: ", traversalTree[traversalIndex].IDContext)
                        -- traversalIndex = traversalIndex+1                        
                    else
                        local newTree = tree:AddTree(tostring(label))
                        -- newTree.IDContext = tostring(tree.Label) .. tostring(traversalIndex)
                        -- table.insert(traversalTree, newTree)
                        -- _P("Added ", traversalTree[traversalIndex].Label, " to IDContext: ", traversalTree[traversalIndex].IDContext)
                        -- traversalIndex = traversalIndex+1
                    end
                else
                    local newTree = tree:AddTree(tostring(label))
                    -- newTree.IDContext = tostring(tree.Label) .. tostring(traversalIndex)
                    newTree.Bullet = true
                    -- table.insert(traversalTree, newTree)
                    -- _P("Added ", traversalTree[traversalIndex].Label, " to IDContext: ", traversalTree[traversalIndex].IDContext)
                    -- traversalIndex = traversalIndex+1
                end
            else
                -- parent not found
            end

        end
    else
        local newTree = tree:AddTree(tostring(currentTable))
        -- newTree.IDContext = tostring(tree.Label) .. tostring(traversalIndex)
        newTree.Bullet = true
        -- table.insert(traversalTree, newTree)
        -- _P("Added ", traversalTree[traversalIndex].Label, " to IDContext: ", traversalTree[traversalIndex].IDContext)
        -- traversalIndex = traversalIndex+1
    end
end


-- for i=1, #traversalTree do
--     traversalTree[i].OnClick = function()
--         _P("OnClick triggered on Treenode: ", traversalTree[i].IDContext)
--         populateChildren(traversalTree[traversalIndex], dump, entityTree.Label)
--     end
-- end


-- function PopulateTree(tree, currentTable)
--     _P(" -----------------------------------------------------------------------------")
--     _P("Iteration: ", iteration)
--     iteration = iteration + 1
--     success, iterator = pcall(pairs, currentTable)
--     if success == true and (type(currentTable) == "table" or type(currentTable) == "userdata") then
--         for label,content in pairs(currentTable) do
--             for _,x in pairs(seen) do
--                 if x == label then
--                     -- _P("Found Duplicate: ", label)
--                 end
--             end
--             table.insert(seen, label)
--             _P("Label :", label, " and Content: " , content)


--                 if content then

--                     -- special case for empty table
--                     local stringify = Ext.Json.Stringify(content, opts)
--                     if stringify == "{}" then
--                         local newTree = tree:AddTree(tostring(label))
--                         PopulateTree(newTree, "{}")
--                     else
                
--                         local newTree = tree:AddTree(tostring(label))
--                         PopulateTree(newTree, content)

--                     end
--                 else
--                     local newTree = tree:AddTree(tostring(label))
--                     newTree.Bullet = true
--                 end
--         end
--     else
--         local newTree = tree:AddTree(tostring(currentTable))
--         newTree.Bullet = true
--     end
-- end


local initRootRow
local initRootCell
local initRootTree

function ReturnInitRootRow()
    return initRootRow
end

function ReturnInitRootCell()
    return initRootCell
end

function ReturnInitRootTree()
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

local savedEntity
local function setSavedEntity(entityUUID)
    savedEntity = entityUUID
end

local function getSavedEntity()
    return savedEntity
end

local savedEntityTree
local function setSavedEntityTree(tree)
    savedEntityTree = tree
end

local function getSavedEntityTree()
    return savedEntityTree
end


 -- call this when user clicks in tree element
function populateChildren(tree, currentTable, treeLabelToPopulate)
    PopulateTree(tree, currentTable,treeLabelToPopulate)
end


local doOnce = 0 -- A "Do Once" for InitializeTree
-- initializes a tab with all components as trees and subtrees
--@param tab TabItem - name of the tab that the components will be displayed under
function InitializeTree(tab, filteredTable)
    local dump
    local rowToPopulate
    local activatedFilter = false

    if filteredTable then
        activatedFilter = true
    end

    -- Decide what to do for each tab
    if tab.Label == "Mouseover" then
        _P("--------------------------USING MOUSEOVER TAB--------------------------")
        if activatedFilter == true then
            dump = filteredTable
        else
            dump = getMouseover()
            setCopiedTable(tab.Label,deepCopy(dump))
        end        

        rowToPopulate = mouseoverTableRow

    elseif tab.Label == "Entity" then
        _P("--------------------------USING ENTITY TAB--------------------------")
        if activatedFilter == true then
            dump = Ext.Entity.Get(getSavedEntity()):GetAllComponents()
        else
            dump = Ext.Entity.Get(getEntityUUID()):GetAllComponents()
            Ext.IO.SaveFile("entityDump.json", Ext.DumpExport(dump))
            setSavedEntity(getEntityUUID())
        end  

        -- setCopiedTable(tab.Label,deepCopy(dump)) -- STACKOVERFLOW !!!!!!!!!!!
        rowToPopulate = entityTableRow

    -- elseif tab.Label == "VisualBank" then
    --     if activatedFilter == true then
    --         dump = filteredTable
    --     else
    --         Ext.Net.PostMessageToServer("RequestCharacterVisual", getEntityUUID())
    --         dump = GetCharacterVisual()
    --         setCopiedTable(tab.Label,deepCopy(dump))
    --     end  
    --     rowToPopulate = visualTableRow
    end
        
    -- Get initial root for deletion of previous dump
    local initRootRow = ReturnInitRootRow()
    local initRootCell = ReturnInitRootCell()
    local initRootTree = ReturnInitRootTree()

    _P("--------- POPULATING", tab.Label, "with", dump, "in tree" , initRootTree, "---------")

    -- Destroy previous dump if it exist, else create new initial one
    if activatedFilter == false then
        if initRootTree ~= nil then

            -- Remove leftover tree
            initRootCell:RemoveChild(initRootTree.Handle)
            -- Create new tree
            local rootTree = initRootCell:AddTree(tab.Label)
            setInitRootTree(rootTree)

            PopulateTree(rootTree, dump, nil)

            -- if tab.Label == "Entity" then
            --     _P("Populating Entitytree")

            --     setSavedEntityTree(rootTree)
            --     local entityTree = getSavedEntityTree()
            -- end
        else
            -- Get row, then create cell/tree and populate it, also serialize the dump
            local rootRow = rowToPopulate
            local rootCell = rootRow:AddCell()
            local rootTree = rootCell:AddTree(tab.Label)
            setInitRootRow(rootRow)
            setInitRootCell(rootCell)
            setInitRootTree(rootTree)
            PopulateTree(rootTree, dump, nil)
            traversalIndex = 1
        end
    else
        -- This should only occur when the search function is used
        _P("Filter Activated, remove old tree and refresh with filtered version:")

        -- initRootCell:RemoveChild(initRootTree.Handle)

        -- Create new tree
        local rootTree = initRootCell[2]:AddTree(tab.Label)
        setInitRootTree(rootTree)
        PopulateTree(rootTree, dump)
        traversalIndex = 1
    end


    if doOnce == 0 then
    -- Create dump info sidebar
        mouseoverDumpInfo = mouseoverTableRow:AddCell():AddText("Pre-Populate")
        entityDumpInfo = entityTableRow:AddCell():AddText("Select Component of your choice \nto populate this field with its actual code.")
        doOnce = doOnce+1
    end

    if tab.Label == "Mouseover" then
        mouseoverDumpInfo.Label = Ext.DumpExport(getMouseover())
    elseif tab.Label == "Entity" then
        entityDumpInfo.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()):GetAllComponents())
    end
    
    ---- TODO fix this
    -- if tab    
    -- else
    --     print(tab ," is not a recognized tab") 
    -- end

    -- _P(traversalTree[3])
    -- _D(traversalTree)
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


-- Function to perform a deep copy of a table
function deepCopy(orig)
    --_P("--------------------------------NEW DEEP COPY CALL--------------------------------")
    local orig_type = type(orig)
    local copy

    success, iterator = pcall(pairs, orig)
    if success == true and (type(orig) == "table" or type(orig) == "userdata") then
        --_P("Type is table or uservalue")
        --_P(type(orig))
        copy = {}
        iteration = 1

        
        for label, content in pairs(orig) do
        --    _P("---------------ITERATION-----------------")
        --     _P("Iteration: ", iteration)
           --_P("New orig_type: ", orig_type)
           -- _P("label: ", label, " with content: ", content)
            
            iteration = iteration+1

            if content then
                --_P("label ", label)
               -- _P("content ", content)
                 copy[deepCopy(tostring(label))] = deepCopy(content)
                --_P("Adding label: ", label, " or  content: ", content, " to copy")
                -- _P("----------------CURRENT DEEP COPY for table or userdata ----------------")
                -- _D(copy)
            else
                copy[deepCopy(label)] = "nil"
               ---_P("Adding ", label, " to copy")
                -- _P("----------------CURRENT DEEP COPY for table or userdata ----------------")
                -- _D(copy)
            end


        end
        if copy and (not #copy == 0) then
           -- _P("----------------IF COPY----------------")
           -- _P("Dump copy:")
           -- _D(copy)
           -- _P("Type of copy:")
           -- _P(type(copy))

            setmetatable(copy, deepCopy(getmetatable(orig)))
        end
    -- elseif copy ~= nil then -- number, string, boolean, etc   
    --     _P("Within Else:")
    --     _P("Type of copy:")
    --     _P(type(copy))
    --     _P("copy", copy, "orig", orig)

    --     copy = orig
    -- end

    else
        --_P("Within Else:")
       -- _P("Type of copy:")
       -- _P(type(copy))
       -- _P("copy", copy, "orig", orig)

        copy = orig
    end

    
    -- _P("----------------CURRENT DEEP COPY----------------")
    -- _D(orig)
    -- _D(copy)
    return copy
end






-- print(originalTable.name)         -- Should print "test"
-- print(originalTable.nested.key)   -- Should print "value"
-- print(copiedTable.name)           -- Should print "modified"
-- print(copiedTable.nested.key)     -- Should print "new_value"

-- function serializeDump(dump)
--     local serializedDump = {}

--     success, iterator = pcall(pairs, dump)
--     if success == true and (type(dump) == "table" or type(dump) == "userdata") then
--         for label,content in pairs(dump) do
--             if content then
--                 local entry = {label, content}
--                 table.insert(serializedDump, entry)
--             else
--                 local entry = {label, nil}
--                 table.insert(serializedDump, entry)
--             end

--             local entry = {label, nil}
--             table.insert(serializedDump, entry)
--         end
--         -- _D(serializedDump)
--         return serializedDump
--     end
-- end

 -- save Slots (contain body, hair, gloves, tails etc.)
 -- @param           - uuid of the NPC
 ---return           - Slots (Table)
-- function saveVisualSet_Slots(uuid)
--     local slots = serializeVisualSetSlots(uuid)
--     local entry = {uuid = uuid, slots = slots}
--     table.insert(OriginalTemplates, entry)
--     -- _D(slots)
-- end