--------------------------------------------------------------------------------------
--
--
--                             Handling the IMGUI "Tabs"
--
--
---------------------------------------------------------------------------------------




--------------------------------------------------------------------------------------------
--                                      VARIABLES
---------------------------------------------------------------------------------------------



-- copied tables 
-- key : label name
-- value: table
local copiedTables = {}

local savedNodes = {}


local initRootRow
local initRootCell
local initRootTree
local savedEntity

-- A "Do Once" for InitializeTree
local doOnce = 0 

---------------------------------------------------------------------------------------------------
--                                           Getters
-------------------------------------------------------------------------------------------------

-- get the Initialized Root Row
--@return initRootRow userdata
function ReturnInitRootRow()
    return initRootRow
end

-- get the Initialized Root Cell
--@return initRootCell userdata
function ReturnInitRootCell()
    return initRootCell
end

-- get the Initialized Root Tree
--@return initRootTree userdata
function ReturnInitRootTree()
    return initRootTree
end

-- get the saved entity
--@return sacedEntity string - uuid of the entity
local function getSavedEntity()
    return savedEntity
end


-- retrieves the copied table
--@param label string - label of tabel that should be returned
--@param dump table   - values
function GetCopiedTable(label)
    -- Entity dumps are too large, so they have to be retrieved from new everytime
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

function GetSavedNodes()
    return savedNodes
end

---------------------------------------------------------------------------------------------------
--                                       Setters
-------------------------------------------------------------------------------------------------

-- set the Initialized Root Row
--@param row userdata
local function setInitRootRow(row)
    initRootRow = row
end

-- set the Initialized Root Cell
--@param cell userdata
local function setInitRootCell(cell)
    initRootCell = cell
end

-- set the Initialized Root Tree
--@param tree userdata
local function setInitRootTree(tree)
    initRootTree = tree
end

-- set the entity
--@param entityUUID string
local function setSavedEntity(entityUUID)
    savedEntity = entityUUID
end


-- sets the copied table (deep copy necessary because of lifetime)
--@param label string - label of table that should be saved
--@param dump table   - values
local function setCopiedTable(label,dump)
    copiedTables[label] = dump
end


---------------------------------------------------------------------------------------------------
--                                      Helper Methods
-------------------------------------------------------------------------------------------------


-- Retrieves the dump of a certain type and saves a copy
-- @param type string
-- @return table dump
local function getAndSaveDump(type)
    local dump

    if type == "Mouseover" then
        dump = GetMouseover()
        setCopiedTable(type, deepCopy(dump))
        
    elseif type == "Entity" then
        -- Entity dump too large, have to save entity instead of dump
        dump = Ext.Entity.Get(getUUIDFromUserdata(GetMouseover())):GetAllComponents()
        setSavedEntity(getUUIDFromUserdata(GetMouseover()))

    elseif type == "VisualBank" then
        Ext.Net.PostMessageToServer("RequestCharacterVisual", getUUIDFromUserdata(GetMouseover()))
        dump = GetCharacterVisual()
        setCopiedTable(type, deepCopy(dump))
    end

    return dump
end



-- retrieves the dump of a certain type and savesa copy
--@param type string
--@param row userdata
local function getRowToPopulate(type)
    if type == "Mouseover" then
        return MouseoverTableRow
    elseif type == "Entity" then
        return EntityTableRow
    elseif type == "VisualBank" then
        return VisualTableRow
    end
end



---------------------------------------------------------------------------------------------------
--                                      Main Methods
-------------------------------------------------------------------------------------------------

-- prints the labels
-- temporary function, can be deleted
local function printLabel(tree)
    success, iterator = pcall(pairs, tree)
    if success == true and (type(tree) == "table" or type(tree) == "userdata") then
        for x,y in pairs(tree) do
            if x == "Label" then
                print(y)
            end
            printLabel(y)
        end
    end
end


-- initializes a tab with all components as trees and subtrees
--@param tab TabItem   - name of the tab that the components will be displayed under
function InitializeTree(tab)

    local dump = getAndSaveDump(tab.Label)
    local rowToPopulate = getRowToPopulate(tab.Label)

    -- Get row, then create cell/tree and populate it
    local rootRow = rowToPopulate
    local rootCell = rootRow:AddCell()
    local rootTree = rootCell:AddTree(tab.Label)

    setInitRootRow(rootRow)
    setInitRootCell(rootCell)
    setInitRootTree(rootTree)

    PopulateTree(rootTree, dump)
    local mouseOverRoot = GetMouseOverRoot()
    --printLabel(mouseOverRoot)

    -- table.insert(savedNodes, TreeToNode(tab.Label, dump))

    if doOnce == 0 then
        -- Create dump info sidebar
        mouseoverDumpInfo = MouseoverTableRow:AddCell():AddText("Pre-Populate")
        entityDumpInfo = EntityTableRow:AddCell():AddText("Select Component of your choice \nto populate this field with its actual code.")
        doOnce = doOnce+1
    end

    if tab.Label == "Mouseover" then
        mouseoverDumpInfo.Label = Ext.DumpExport(GetMouseover())
    elseif tab.Label == "Entity" then
        entityDumpInfo.Label = Ext.DumpExport(Ext.Entity.Get(getUUIDFromUserdata(GetMouseover())):GetAllComponents())
    end
    

end



-- refreshes tab if a search term is searched
--@param tab TabItem         - name of the tab that the components will be displayed under
--@param filteredTable table - the new information
function RefreshTree(tab, filteredTable)
    local rowToPopulate = getRowToPopulate(tab.Label)


    -- Get initial root for deletion of previous dump
    local initRootRow = ReturnInitRootRow()
    local initRootCell = ReturnInitRootCell()
    local initRootTree = ReturnInitRootTree()

    -- Destroy previous dump if it exist

    -- Remove leftover tree
    initRootCell:RemoveChild(initRootTree.Handle)
    -- Create new tree
    local rootTree = initRootCell:AddTree(tab.Label)
    setInitRootTree(rootTree)

    PopulateTree(rootTree, filteredTable)

    if tab.Label == "Entity" then
        setSavedEntityTree(rootTree)
        local entityTree = getSavedEntityTree()
    end

    --initRootCell:RemoveChild(initRootTree.Handle)

    -- Create new tree
    local rootTree = initRootCell[2]:AddTree(tab.Label)
    setInitRootTree(rootTree)
    PopulateTree(rootTree, filteredTable)


    if tab.Label == "Mouseover" then
        mouseoverDumpInfo.Label = Ext.DumpExport(GetMouseover())
    elseif tab.Label == "Entity" then
        entityDumpInfo.Label = Ext.DumpExport(Ext.Entity.Get(getUUIDFromUserdata(getSavedEntity())):GetAllComponents())
    end
    
end

