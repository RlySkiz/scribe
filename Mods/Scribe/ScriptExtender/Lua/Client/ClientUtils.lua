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

local function populateTree(tree, currentTable)
    success, iterator = pcall(pairs, currentTable)
    if success == true and (type(currentTable) == "table" or type(currentTable) == "userdata") then
        for label,content in pairs(currentTable) do
                if content then
                    -- _P(label)
                    -- _D(label)
                    local newTree = tree:AddTree(tostring(label))
                    populateTree(newTree, content)
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

-- initializes a tab with all components as trees and subtrees
--@param tab TabItem - name of the tab that the components will be displayed under
function InitializeTab(tab)

    if tab.Label == "Mouseover" then
        local mouseover = getMouseover()
        populateTree(mouseoverDumpTree,mouseover)

        elseif tab.Label == "Entity" then
            local entity = Ext.Entity.Get(getEntityUUID()):GetAllComponents()
            populateTree(entityDumpTree,entity)
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



