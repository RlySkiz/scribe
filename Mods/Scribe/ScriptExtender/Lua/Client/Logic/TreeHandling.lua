--------------------------------------------------------------------------------------
--
--
--                 Handling IMGUI Trees and Custom Node Trees
--
--
---------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------
--                                          Methods
---------------------------------------------------------------------------------------



-- finds a value based on the key in a tree
-- @param tree table - the tree to be searched
-- @param searchTerm any - the value to be searched
-- @return value any - the value that matches the search term
local function find(child, searchTerm, tree)
    success, iterator = pcall(pairs, tree)
    if success == true and (type(tree) == "table" or type(tree) == "userdata") then
        for label, content in pairs(tree) do
            --_P("Checking if ", label, " == ", searchTerm)
            if label == searchTerm then
                _P(" Found content is ", content)
                PopulateTree(child,content)
                return content
            else
                local result = find(searchTerm, content)
            end
        end
    else
        if tree == searchTerm then
            return tree
        end
    end
end

-- Adds the OnClick function that populates all direct descendandts of a tree
--@param treeRoot tree - parent
local function populateChildrenOnClick(treeRoot)

    -- TODO - make variable, we need more than just mouseover
    local mouseover = GetCopiedTable("Mouseover")

    for i=1, #treeRoot.Children do
        
        local child = treeRoot.Children[i]
        local childLabel = child.Label

        mouseoverContent = find(child, childLabel, mouseover)

        _P("Done with iteration ", i)

        -- if child label matches any mouseover label then 
        -- populate child with corresponding mouseOverContent

        child.OnClick = function()

            --PopulateTree(child, mouseoverContent)
        end
    end
end




local ID = 0
-- Populate a tree
--@param tree userdata/Tree      - tree that the children will be added to
--@param currentTable table      - table with the label, content pairs
function PopulateTree(tree, currentTable)

    success, iterator = pcall(pairs, currentTable)
    if success == true and (type(currentTable) == "table" or type(currentTable) == "userdata") then
        for label,content in pairs(currentTable) do
            if content then
                -- special case for empty table
                local stringify = Ext.Json.Stringify(content, STRINGIFY_OPTIONS)
                if stringify == "{}" then
                    local newTree = tree:AddTree(tostring(label))
                    newTree.Bullet = true
                else
                    local newTree = tree:AddTree(tostring(label))
                end
            else
                local newTree = tree:AddTree(tostring(label))
                newTree.Bullet = true
            end

        end
    else
        local newTree = tree:AddTree(tostring(currentTable))
        newTree.Bullet = true

    end
    -- Add OnClickFunctionality
    --populateChildrenOnClick(tree)
end



-- Recursive function - not used anymore because of memory usage

-- Populate a tree
--@param tree userdata/Tree      - tree that the children will be added to
--@param currentTable table      - table with the label, content pairs
--@param recursive bool          - whether to populate recursively or not (used for large data)
-- function PopulateTree(tree, currentTable, recursive)

--     success, iterator = pcall(pairs, currentTable
--     if success == true and (type(currentTable) == "table" or type(currentTable) == "userdata") then
--         for label,content in pairs(currentTable) do
--                 if content then

--                     -- special case for empty table
--                     local stringify = Ext.Json.Stringify(content, STRINGIFY_OPTIONS)
--                     if stringify == "{}" then
--                         local newTree = tree:AddTree(tostring(label))
--                         if recursive then
--                             PopulateTree(newTree, "{}")
--                         end
--                     else
                
--                         local newTree = tree:AddTree(tostring(label))
--                         if recursive then
--                             PopulateTree(newTree, content)
--                         end
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


