--------------------------------------------------------------------------------------
--
--
--                                      Main Class
--                                 Interaction Handling
--
---------------------------------------------------------------------------------------

Scribe = {}
Scribe.__index = Scribe

local w = Ext.IMGUI.NewWindow("Scribe")


local devMode
local function inDev()
    if devMode == true then
        return true
    else
        return false
    end
end

---------------------------------------------------------------------------------------------------
--                              Generating of Mouseover Data
---------------------------------------------------------------------------------------------------

local scribeMap = {
    ["Mouseover"] = { Data = {}, RootTree = {}, SerializedTree = {}, DumpText = {}},
    ["Entity"] = { Data = {}, RootTree = {}, SerializedTree = {}, DumpText = {}},
    ["Visual"] = { Data = {}, RootTree = {}, SerializedTree = {}, DumpText = {}},
    ["VisualBank"] = { Data = {}, RootTree = {}, SerializedTree = {}, DumpText = {}},
    ["Materials"] = { Data = {}, RootTree = {}, SerializedTree = {}, DumpText = {}},
    ["Textures"] = { Data = {},  RootTree = {}, SerializedTree = {}, DumpText = {}},
}

local function getMouseover()
    -- _P("getMouseover")
    local mouseover = Ext.UI.GetPickingHelper(1) -- 1 = Player1? - Neccessary
    if mouseover ~= nil then
    -- setSavedMouseover(mouseover)
        return mouseover
    else
        _P("[Scribe] Not a viable mouseover!")
    end
end

local function stringContains(str, sub)
    -- Make the comparison case-insensitive
    str = str:lower()
    sub = sub:lower()
    return (string.find(str, sub, 1, true) ~= nil)
end

local function getUUIDFromUserdata(mouseover)
    local entity = mouseover.Inner.Inner[1].GameObject
    if entity ~= nil then
        return Ext.Entity.HandleToUuid(entity)
    else
        _P("[Scribe] getUUIDFromUserdata(mouseover) - Not an entity!")
    end
end

-- local function getMouseoverHandle(mouseover)
--     local entity = mouseover.Inner.Inner[1].GameObject
--     if entity ~= nil then
--         return Ext.Entity.HandleToUuid(entity)
--     else
--         _P("[Scribe] getUUIDFromUserdata(mouseover) - Not an entity!")
--     end
-- end

local function search(txt, tbl)
    for _,element in pairs(tbl) do
        if stringContains(element.Label, txt) then
            element.Visible = true
        else
            element.Visible = false
        end
    end
end

local function deepCopy(orig)
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

local function getPropertyOrDefault(obj, propertyName, defaultValue)
    local success, value = pcall(function() return obj[propertyName] end)
    if success then
        return value or defaultValue
    else
        return defaultValue
    end
end

local function sortData(data)
    if type(data) == "table" or type(data) == "userdata" then
        local array = {}
        for key, value in pairs(data) do
            table.insert(array, {key = key, value = value})
        end

        table.sort(array, function(a, b)
            -- Use getPropertyOrDefault to handle cases where keys may be complex
            local keyA = getPropertyOrDefault(a.key, "Uuid", a.key)
            local keyB = getPropertyOrDefault(b.key, "Uuid", b.key)

            -- Try to convert the keys to numbers if possible
            local numKeyA, numKeyB = tonumber(keyA), tonumber(keyB)

            if numKeyA and numKeyB then
                return numKeyA < numKeyB
            else
                -- Compare keys as strings if they can't be converted to numbers
                return tostring(keyA) < tostring(keyB)
            end
        end)

        return array, data
    else
        return data, data
    end
end

-- getPropertyOrDefault(entry.value, "Uuid", nil)


local function generateData()
    local allTabs = Tab:getAllTabs()
    for _,entry in pairs(allTabs) do
        if entry.tab.Label == "Mouseover"  then
            local mouseover = getMouseover()
            -- scribeMap[entry.tab.Label].Data = deepCopy(mouseover)
            scribeMap[entry.tab.Label].Data = Ext.Types.Serialize(mouseover)
        elseif entry.tab.Label == "Entity" then
            local mouseover = getMouseover()
            local uuid = getUUIDFromUserdata(mouseover)
            if uuid ~= nil then
                -- Ext.Net.PostMessageToServer("Scribe_RequestEntity", uuid) -- Re-enable when we added server request for every compnode recursion
                local data = Ext.Entity.Get(uuid):GetAllComponents()
                scribeMap[entry.tab.Label].Data = data
            end
        elseif entry.tab.Label == "Visual" then
            local mouseover = getMouseover()
            local uuid = getUUIDFromUserdata(mouseover)
            if uuid ~= nil then
                local data = Ext.Entity.Get(uuid).Visual
                scribeMap[entry.tab.Label].Data = data
            end
        -- elseif entry.tab.Label == "VisualBank" then
        --     Ext.Net.PostMessageToServer("Scribe_RequestFromServer_VisualResourceID", Ext.Json.Stringify(uuid))
        --     -- Server saves return to scribeMap
        end
    end
end



local function reverseTable(t)
    local reversed = {}
    for i = #t, 1, -1 do
        table.insert(reversed, t[i])
    end
    -- _P("REVERSETABLE")
    -- _D(reversed)
    return reversed
end

local function tryGetComponentValue(uuid, previousComponent, components)
    local entity = Ext.Entity.Get(uuid)
    if #components == 1 then -- End of recursion
        if not previousComponent then
            local value = getPropertyOrDefault(entity, components[1], nil)
            return value
        else
            local value = getPropertyOrDefault(previousComponent, components[1], nil)
            return value
        end
    end

    local currentComponent
    if not previousComponent then -- Recursion
        currentComponent = getPropertyOrDefault(entity, components[1], nil)
        -- obscure cases
        if not currentComponent then
            return nil
        end
    else
        currentComponent = getPropertyOrDefault(previousComponent, components[1], nil)
    end

    table.remove(components, 1)

    -- Return the result of the recursive call
    return tryGetComponentValue(uuid, currentComponent, components)
end


local function getFreshComponentData(objUuid, comps)
    return tryGetComponentValue(objUuid, nil, comps)
end

local function tryGetMouseoverComponentValue(mouseoverData, previousComponent, components)
    if #components == 1 then -- End of recursion
        if not previousComponent then
            -- Directly access component from mouseoverData
            local value = mouseoverData[components[1]] or nil
            return value
        else
            -- Directly access component from previous component
            local value = previousComponent[components[1]] or nil
            return value
        end
    end

    local currentComponent
    if not previousComponent then -- Recursion
        -- Directly access the first component from mouseoverData
        currentComponent = mouseoverData[components[1]] or nil
        if not currentComponent then
            return nil -- Handle obscure cases where the component doesn't exist
        end
    else
        -- Access next component from the previous component
        currentComponent = previousComponent[components[1]] or nil
    end

    -- Remove first component and continue recursion
    table.remove(components, 1)

    return tryGetMouseoverComponentValue(mouseoverData, currentComponent, components)
end

local function getMouseoverComponentData(mouseoverData, comps)
    return tryGetMouseoverComponentValue(mouseoverData, nil, comps)
end


function Scribe:getScribeMap(label)
    return scribeMap[label]
end

local function getData(label)
    return scribeMap[label].Data
end

---------------------------------------------------------------------------------------------------
--                             Generating of Imgui Elements
---------------------------------------------------------------------------------------------------

local function IsScalar(v) -- by Norbyte
    local ty = Ext.Types.GetValueType(v)
    return ty == "nil" or ty == "string" or ty == "number" or ty == "boolean" or ty == "Enum" or ty == "Bitfield"
end

local function destroyChildren(obj)
    if obj.Children and #obj.Children > 0 then
        for _,child in pairs(obj.Children) do
            child:Destroy()
        end
    end
end

local function populateDumpArea(dumpArea, data)
    destroyChildren(dumpArea)
    local dumpTable = dumpArea:AddTable("",1)
    -- local dumpColumn = dumpTable:AddColumn("",{"WidthFixed"})
    local dumpColumn = dumpTable:AddColumn("",{"WidthStretch"})
    dumpTable.Borders = false
    dumpTable.SizingStretchProp = true
    -- _P("DumpArea Children")
    -- _D(dumpArea.Children)
    local dumpRoot = dumpTable:AddRow():AddCell():AddInputText("")
    dumpRoot.ItemWidth = 500
    dumpRoot.Multiline = true
    dumpRoot.Text = Ext.DumpExport(data)
end

local function valueChange(newVal, template, components)
    local compVal = tryGetComponentValue(template, nil, components)
    -- _P("Setting new Value")
    compVal = newVal
end

local function saveEntityCheck(possibleEntity)
    local entityComponents = false
    local success, _ = pcall(function()
        entityComponents = possibleEntity:GetAllComponents()
    end)
    return entityComponents
end

local function isIterable(t)
    local isIterable = false
    -- Check if userdata behaves like a table by trying to iterate over it
    local success, _ = pcall(function()
        for _ in pairs(t.value) do
            isIterable = true
            break
        end
    end)
    return isIterable
end

local function hasTableInTable(t)
    for _, value in pairs(t) do
        if type(value) == "table" then
            return true -- Return true as soon as a table is found
        end
    end
    return false -- Return false if no tables are found
end

local function populateScalarArea(scalarArea, data, parent)
    destroyChildren(scalarArea)
    local what = scalarArea:AddInputText("")
    what.Text = parent.Label
    local scalarTable = scalarArea:AddTable("",2) -- Right Top
    local keyColumn = scalarTable:AddColumn("",{"WidthFixed"})
    local valueColumn = scalarTable:AddColumn("",{"WidthStretch"})
    scalarTable.Borders = true
    -- scalarTable.Borders = false
    scalarTable.SizingFixedFit = true
    -- scalarTable.SizingFixedSame = true
    -- scalarTable.SizingStretchSame = true
    -- scalarTable.SizingStretchProp = true
    -- scalarTable.NoHostExtendX = true
    -- _P("Iterating entries")

    local function createNewValueButton(valuefield, parent)
        local newValButton = parent:AddButton("Save")
        newValButton.SameLine = true
        newValButton.Visible = false
        newValButton.OnClick = function()
            -- valueChange(value.Text, origTemplate, entry.key) -- NYI
            newValButton.Visible = false
        end
        valuefield.OnChange = function()
            newValButton.Visible = true
        end
    end
    for i,entry in ipairs(data) do
        if not isIterable(entry.key) then
            if IsScalar(entry.value) then
                -- _P(tostring(entry.key) .. " is a " ..type(entry.value) .. " of value: " .. tostring(entry.value))
                local scalarRoot = scalarTable:AddRow()
                local scalarnamecell = scalarRoot:AddCell()
                local scalarvaluecell = scalarRoot:AddCell()
                if type(entry.value) == "string" or type(entry.value) == "number" then
                    local name = scalarnamecell:AddText(entry.key)
                    local valuefield = scalarvaluecell:AddInputText("")
                    valuefield.Text = tostring(entry.value)
                    valuefield.SameLine = true
                    -- createNewValueButton(valuefield, scalarvaluecell)

                elseif type(entry.value) == "boolean" then
                    local name = scalarnamecell:AddText(entry.key)
                    local boolButton = scalarvaluecell:AddCheckbox("")
                    boolButton.SameLine = true
                    if entry.value == "true" then
                        boolButton.Checked = true
                    end
                    boolButton.OnChange = function()
                        -- _P(entry.key .. " bool changed to " .. tostring(boolButton.Checked))
                        -- valueChange(boolButton.Checked, origTemplate, entry.key)
                    end
                elseif type(entry.value) == "userdata" then
                    local name = scalarnamecell:AddText(entry.key)
                    if isIterable(entry.value) then
                        -- Handle userdata as if it were a table
                        local valuefields = {}
                        for _, value in pairs(entry.value) do
                            local valuefield = scalarvaluecell:AddInputText("")
                            valuefield.Text = tostring(value)
                            table.insert(valuefields, valuefield)
                            -- createNewValueButton(valuefield, scalarvaluecell)
                        end
                    else
                        -- Fallback: Handle userdata as string-like
                        local valuefield = scalarvaluecell:AddInputText("")
                        valuefield.Text = tostring(entry.value)
                        valuefield.SameLine = true
                        -- createNewValueButton(valuefield, scalarvaluecell)
                    end
                end
            else
                if getPropertyOrDefault(entry.value, "Uuid", nil) then
                    local entityUUID = entry.value.Uuid.EntityUuid
                    local entity = Ext.Entity.Get(entityUUID)
                    local scalarRoot = scalarTable:AddRow()
                    local scalarnamecell = scalarRoot:AddCell()
                    local scalarvaluecell = scalarRoot:AddCell()
                    local key
                    local name
                    if entity.DisplayName then
                    key = scalarnamecell:AddText(entry.key .. ":")
                    name = scalarnamecell:AddText("("..Ext.Loca.GetTranslatedString(entity.DisplayName.NameKey.Handle.Handle)..")")
                    else
                        key = scalarnamecell:AddText(entry.key .. ": ")
                    end
                    local valuefield = scalarvaluecell:AddInputText("")
                    valuefield.Text = entityUUID
                end
            end
        else
            local scalarRoot = scalarTable:AddRow()
            local scalarnamecell = scalarRoot:AddCell()
            local scalarvaluecell = scalarRoot:AddCell()
            local name = scalarnamecell:AddText(entry.key)
            if isIterable(entry.value) then
                -- Handle userdata as if it were a table
                local valuefields = {}
                for _, value in pairs(entry.value) do
                    local valuefield = scalarvaluecell:AddInputText("")
                    valuefield.Text = tostring(value)
                    table.insert(valuefields, valuefield)
                    -- createNewValueButton(valuefield, scalarvaluecell)
                end
            else
                -- Fallback: Handle userdata as string-like
                local valuefield = scalarvaluecell:AddInputText("")
                valuefield.Text = tostring(entry.value)
                valuefield.SameLine = true
                -- createNewValueButton(valuefield, scalarvaluecell)
            end
        end
    end
end

local function populateRoots(contentAreas, tab)
    local searchTable = {}
    local treeRoot = contentAreas.treeArea:AddRow():AddCell():AddTree("Root")
    treeRoot.Leaf = true
    if tab == "Mouseover" then
        treeRoot.Label = tab
    else
        treeRoot.Label = getUUIDFromUserdata(getMouseover())
    end
    treeRoot.DefaultOpen = true
    local scalarArea = contentAreas.scalarArea
    local dumpArea = contentAreas.dumpArea
    local data = getData(tab)
    local sortedData, unsortedData = sortData(data)

    treeRoot.OnClick = function()
        local freshCompData = getFreshComponentData(treeRoot.Label, parents)
        sortedData, unsortedData = sortData(freshCompData)
        for i,content in ipairs(sortedData) do
            populateScalarArea(scalarArea, sortedData, treeRoot)
            populateDumpArea(dumpArea, sortedData)
        end
    end

    local function getParentsUntilRoot(node)
        local listOfParents = {}
        table.insert(listOfParents, node.Label)
        local function getParentsUntilRootRecursive(node)
            local parent = node.ParentElement
            local parentLabel = node.ParentElement.Label

            if parentLabel == treeRoot.Label then
                local reversed = reverseTable(listOfParents)
                return reversed
            else
                table.insert(listOfParents, parentLabel)
                return getParentsUntilRootRecursive(parent)
            end

            return listOfParents
        end
        local listOfParents = getParentsUntilRootRecursive(node)
        -- _P("ListofParents")
        -- _D(listOfParents)
        return listOfParents
    end

    --- func desc
    ---@param data any
    ---@param parent any
    ---@param type any "Mouseover" or "Entity"
    local function recursiveBuildComponents(data, parent)
        -- _P("-------------------------------recursiveBuildComponents----------------------------------")
        -- _P("parent ", parent.Label)
        if type(data) == "table" and #data > 0 then
            for i,content in ipairs(data) do
                -- if tab == "Entity" and content.key ~= "Visual" then -- Don't do anything for an entities .Visual, we have a seperate tab for this
                    if isIterable(content.key) then -- And key is iterable
                        for _,comp in pairs(content.key) do
                            local compnode = parent:AddTree(content.key)
                            table.insert(searchTable, compnode)
                            
                            local freshCompData
                            local sortedData = content.value
                            local unsortedData

                            local parents = getParentsUntilRoot(compnode)
                            if tab == "Mouseover" then
                                sortedData, unsortedData = sortData(content.value)

                                -- _P("TAB IS MOUSEOVER")
                                freshCompData = getMouseoverComponentData(getMouseover(),parents)
                                -- _P("--------------------------FRESH MOUSEOVER DATA-------------------")
                                -- _D(freshCompData)

                            else
                                -- Else its an entity, get the content.value by recursively going through parent components
                                
                                -- _P("Parents")
                                -- _D(parents)
                                -- for _,parent in pairs(parents) do
                                --     _D(parent)
                                -- end

                                
                                freshCompData = getFreshComponentData(treeRoot.Label, parents)
                                -- _P("Fresh Component Data")
                                -- _D(freshCompData)

                                sortedData, unsortedData = sortData(freshCompData)
                            end

                            -- _P("Sorted Data")
                            -- _D(sortedData)

                            -- for _,content in pairs(sortedData) do
                            --     _P(type(content.value))
                            -- end

                            if TableSize(compnode.Children) == 0 then -- Only create if it hasn't been already
                                recursiveBuildComponents(sortedData, compnode)
                            end
                            populateScalarArea(scalarArea, sortedData, compnode)
                            populateDumpArea(dumpArea, freshCompData)
                        end
                    elseif not isIterable(content.key) and not IsScalar(content.value) then
                        if not getPropertyOrDefault(content.value, "Uuid", nil) then

                            local compnode = parent:AddTree(content.key)
                            if type(content.value) == "function" then
                                compnode.Label = content.key .. "()"
                            end
                            compnode.DefaultOpen = false
                            if type(content.value) == "table" or type(content.value) == "userdata" then
                                if isIterable(content.value) == false then
                                    compnode.Bullet = true
                                else
                                    compnode.Bullet = false
                                end
                                if TableSize(content.value) == 0 then
                                    compnode.Bullet = false
                                    compnode.Leaf = true
                                end
                                if hasTableInTable(content.value) then
                                    compnode.Bullet = false
                                    compnode.Leaf = false
                                end
                                if content.value ~= nil then
                                    compnode.OnClick = function()

                                        local freshCompData
                                        local sortedData = content.value
                                        local unsortedData

                                        local parents = getParentsUntilRoot(compnode)
                                        if tab == "Mouseover" then
                                            sortedData, unsortedData = sortData(content.value)

                                            freshCompData = getMouseoverComponentData(getMouseover(),parents)
                                            -- _P("--------------------------FRESH MOUSEOVER DATA-------------------")
                                            -- _D(freshCompData)
                                        else
                                            -- Else its an entity, get the content.value by recursively going through parent components
                                            
                                            -- _P("Parents")
                                            -- _D(parents)
                                            -- for _,parent in pairs(parents) do
                                            --     _D(parent)
                                            -- end
                                            
                                            freshCompData = getFreshComponentData(treeRoot.Label, parents)
                                            -- _P("Fresh Component Data")
                                            -- _D(freshCompData)

                                            sortedData, unsortedData = sortData(freshCompData)
                                        end

                                        -- _P("Sorted Data")
                                        -- _D(sortedData)

                                        -- for _,content in pairs(sortedData) do
                                        --     _P(type(content.value))
                                        -- end

                                        if TableSize(compnode.Children) == 0 then -- Only create if it hasn't been already
                                            recursiveBuildComponents(sortedData, compnode)
                                        end
                                        populateScalarArea(scalarArea, sortedData, compnode)
                                        populateDumpArea(dumpArea, freshCompData)
                                    end
                                end
                            end
                        -- else -- If value is not scalar and key is an entity
                        --     destroyChildren(scalarArea)
                        --     local what = scalarArea:AddInputText("")
                        --     what.Text = parent.Label
                        --     local scalarTable = scalarArea:AddTable("",2) -- Right Top
                        --     scalarTable.SizingStretchProp = true
                        --     _D(content.key)
                        --     local entityUUID = content.key.Uuid.EntityUuid
                        --     local entity = Ext.Entity.Get(entityUUID)
                        --     local scalarRoot = scalarTable:AddRow()
                        --     local scalarnamecell = scalarRoot:AddCell()
                        --     local scalarvaluecell = scalarRoot:AddCell()
                        --     local name = scalarnamecell:AddText(Ext.Loca.GetTranslatedString(entity.DisplayName.NameKey.Handle.Handle))
                        --     local uuid = scalarnamecell:AddText(entityUUID)

                        --     local valuefield = scalarvaluecell:AddInputText("")
                        --     valuefield.Text = content.value
                        end 
                    end
                -- end
            end
        else
            -- _P("-----------------ELSE-------------")
            populateScalarArea(scalarArea, data, parent)
            populateDumpArea(dumpArea, data)
        end
    end
    recursiveBuildComponents(sortedData, treeRoot)
end

local function buildContentArea(contentArea)
    local contentRow = contentArea:AddRow()
    contentArea.Borders = false

    local treeArea = contentRow:AddCell():AddTable("",1) -- Left Side
    treeArea.Borders = false
    treeArea.SizingFixedFit = true
    treeArea.ScrollY = true
    -- treeArea.SizingStretchProp = true
    -- treeArea.SizingStretchSame = true
    -- treeArea.SizingFixedSame = true
    -- treeArea.ScrollX = true

    local scalarDumpWrapper = contentRow:AddCell():AddTable("",1) -- Right side
    scalarDumpWrapper.Borders = false
    -- scalarDumpWrapper.SizingFixedFit = true
    -- scalarDumpWrapper.SizingFixedSame = true
    -- scalarDumpWrapper.ScrollY = true
    -- scalarDumpWrapper.SizingStretchProp = true
    -- scalarDumpWrapper.SizingStretchSame = true
    -- scalarDumpWrapper.NoHostExtendX = true
    
    
    local scalarArea = scalarDumpWrapper:AddRow():AddCell() -- Right Top
    local dumpArea = scalarDumpWrapper:AddRow():AddCell() -- Right Bottom


    return treeArea, scalarArea, dumpArea
end

local function populateTab(label)
    local tab = Tab:getTab(label)
    local contentArea = Tab:getContentArea(label)
    local search = Tab:getSearch(label)

    destroyChildren(contentArea)
    local contentAreas = {}
    contentAreas.treeArea, contentAreas.scalarArea, contentAreas.dumpArea = buildContentArea(contentArea)
    populateRoots(contentAreas, label)
end

---------------------------------------------------------------------------------------------------
--                                  Initilization  of  GUI
---------------------------------------------------------------------------------------------------

local tabs = {
    "Mouseover",
    "Entity",
    "Visual",
    -- "VisualBank",
    -- "Materials",
    -- "Textures"
}
local tabElements = {}
local function initializeScribe(tab)
    local dev = tab:AddCheckbox("Developer Mode")
    dev.Visible = false -- NYI
    dev.OnChange = function()
        devMode = true
    end
    local keybinds = tab:AddText("Press: 2 = Generates Dump files | 3 = Populate Tabs based on Mouseover")
    local tabbar = tab:AddTabBar("")
    for _,label in ipairs(tabs) do
        local tab = Tab:new(label, tabbar)
        table.insert(tabElements, tab)
    end
end

---------------------------------------------------------------------------------------------------
--                                          Listeners
---------------------------------------------------------------------------------------------------
local mcmTabFocused = true -- TODO: Find out how to actually get this information
-- local mcmTabFocused = false
-- Ext.ModEvents.BG3MCM["MCM_Mod_Tab_Activated"]:Subscribe(function(e, payload)
--     local p = Ext.Json.Parse(payload)
--     if p.tabName == "Scribe" then
--         _P("test")
--         mcmTabFocused = true
--     else
--         _P("test2")
--         mcmTabFocused = true
--     end
-- end)
w.Open = false
w.Closeable = true
Ext.Events.KeyInput:Subscribe(function (e)
    if mcmTabFocused == true then -- Only Execute Keybinds when our Tab is focused
        if e.Event == "KeyDown" and e.Repeat == false then
            if e.Key == "BACKSLASH" then
                if w.Open == true then
                   w.Open = false 
                else
                    w.Open = true 
                end
            end
            if e.Key == "NUM_2" and w.Open == true then
                Ext.IO.SaveFile("Scribe/mouseoverDump.json", Ext.DumpExport(getMouseover()))
                Ext.IO.SaveFile("Scribe/entityDump.json", Ext.DumpExport(Ext.Entity.Get(getUUIDFromUserdata(getMouseover())):GetAllComponents()))
            end

            -- Displays Dump in IMGUI windows
            if e.Key == "NUM_3" and w.Open == true then
                for _,content in pairs(scribeMap) do
                    content.Data = {}
                end
                for _,label in pairs(tabs) do
                    if Tab:getTab(label) then
                        Tab:getTab(label).Visible = false
                    end
                end
                generateData()

                for _,label in pairs(tabs) do
                    -- _P("SCRIBEMAP ".. label)
                    -- _D(scribeMap[label])
                    if TableSize(scribeMap[label].Data) > 0 then
                        if Tab:getTab(label) then
                            Tab:getTab(label).Visible = true
                        end
                        populateTab(label)
                    end
                end

            end
        end
    end
end)

Ext.Events.NetMessage:Subscribe(function(e)
    if (e.Channel == "Scribe_SendEntity") then
        local payload = Ext.Json.Parse(Ext.Json.Parse(e.Payload))
        _D(payload)
        scribeMap["Entity"].Data = payload
    elseif (e.Channel == "Scribe_ToClient_VisualResourceID") then
        -- _P("SendCharacterVisualResourceID recieved")
        local characterVisualResourceID = Ext.Json.Parse(e.Payload)
        -- _P(characterVisualResourceID)
        local characterVisual = Ext.Resource.Get(characterVisualResourceID, "CharacterVisual")
        -- scribeMap["VisualBank"].Data = characterVisual
        scribeMap["VisualBank"].Data = deepCopy(characterVisual)
        -- InitializeScribeTree("VisualBank")
    end
end)

-- Mouseover has to be populated from client
-- For Entity we need additional ServerEntity information so we need to request dump from server
-- Visual is Entity.Visual.Visual
-- VisualBank can be populated from client but needs something from the ServerEntity dump, namely .ServerCharacter.Template.CharacterVisualResourceID
-- ;then generate dump via Ext.Resource.Get(uuid, "CharacterVisual")

---------------------------------------------------------------------------------------------------
--                                          MCM
---------------------------------------------------------------------------------------------------

-- Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, "Scribe", function(tab)
--     initializeScribe(tab)
-- end)
initializeScribe(w)