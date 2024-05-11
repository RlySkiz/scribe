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
    


-- Recursive function to create a nested tree structure for components and their properties
function CreateComponentTree(tree, components)
    -- Create a table to store sorted component names
    local sortedComponentNames = {}
    
    -- Populate the table with component names
    for componentName, _ in pairs(components) do
        table.insert(sortedComponentNames, componentName)
    end

    -- Sort the table alphabetically
    table.sort(sortedComponentNames)
    
    -- Iterate over sorted component names
    for _, componentName in ipairs(sortedComponentNames) do
        local componentData = components[componentName] -- Get the component data
        
        -- Add a tree node for the component
        local componentNode = tree:AddTree(componentName)
        
        -- Iterate over each property of the component
        for propName, propValue in pairs(componentData) do
            -- Check if the property is a nested table (sub-component)
            if type(propValue) == "table" then
                -- Add a subtree for sub-components
                local nestedTree = componentNode:AddTree(propName)
                -- Recursively create nested tree structure for sub-components
                CreateSubComponentTree(nestedTree, propValue)
            else
                -- Add property to the component subtree
                if type(propValue) == "string" then
                    -- Check if the string matches the pattern of a GUID
                    if string.match(propValue, "%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x") then
                        -- Add the GUID as a new tree node
                        componentNode:AddTree(propName .. ": " .. tostring(propValue))
                    else
                        componentNode:AddText(propName .. ": " .. tostring(propValue))
                    end
                else
                    componentNode:AddText(propName .. ": " .. tostring(propValue))
                end
            end
        end
    end
end
    
-- Recursive function to create a nested tree structure for sub-components
function CreateSubComponentTree(tree, subComponents)
    -- Check if subComponents is a table
    if type(subComponents) == "table" then
        -- Iterate over each property of the sub-components
        for subComponentName, subComponentValue in pairs(subComponents) do
            -- Add a tree node for the sub-component
            local subComponentNode = tree:AddTree(subComponentName)
            
            -- Check if the sub-component value is a table (another component)
            if type(subComponentValue) == "table" then
                -- If the sub-component value is an array
                if #subComponentValue > 0 then
                    -- Iterate over each element of the array
                    for i, value in ipairs(subComponentValue) do
                        -- Check if the element is a string and matches the pattern of a GUID
                        if type(value) == "string" and string.match(value, "%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x") then
                            -- Add the GUID as a new tree node
                            subComponentNode:AddTree(tostring(i) .. ": " .. value)
                        else
                            -- Recursively create nested tree structure for sub-components
                            CreateComponentTree(subComponentNode, {value})
                        end
                    end
                else
                    -- Recursively create nested tree structure for sub-components
                    CreateComponentTree(subComponentNode, subComponentValue)
                end
            else
                -- Add sub-component to the tree
                if type(subComponentValue) == "string" then
                    -- Check if the string matches the pattern of a GUID
                    if string.match(subComponentValue, "%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x") then
                        -- Add the GUID as a new tree node
                        subComponentNode:AddTree(subComponentValue)
                    else
                        subComponentNode:AddText(subComponentValue)
                    end
                else
                    subComponentNode:AddText(tostring(subComponentValue))
                end
            end
        end
    end
end



local function populateTree(tree, currentTable)

        success, iterator = pcall(pairs, currentTable)
        if success == true and (type(currentTable) == "table" or type(currentTable) == "userdata") then
            for label,content in pairs(currentTable) do
                    if content then
                        _P(label)
                        _D(label)
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



