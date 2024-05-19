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
--@param tree tree - the tree to be searched
--@return value any - the value that matches the search term
local function find(searchTerm, tree)

    success, iterator = pcall(pairs, tree)
    if success == true and (type(tree) == "table" or type(tree) == "userdata") then
        for label,content in pairs(tree) do
            _P("Checking if ", label , " == ", searchTerm)
            if label == searchTerm then
                _P("SUCCESS")
                _P("RETURNING ", content)
                return content
                
            else
                return find(searchTerm, content)
            end
        end
    end
    return nil
end


-- Adds the OnClick function that populates all direct descendandts of a tree
--@param treeRoot tree - parent
local function populateChildrenOnClick(treeRoot)
    _P("Called populateChildrenOnClick")


    local mouseover = GetSavedMouseover()

    for i=1, #treeRoot.Children do
        
        local child = treeRoot.Children[i]
        local childLabel = child["Label"]
        _P("childLabel ", childLabel)
        _P(find(childLabel, mouseover))

        -- if child label matches any mouseover label then 



        --_D(child)
        child.OnClick = function()
            --local mouseoverComponent = GetPropertyOrDefault(mouseover, node.Label, nil)
            local label = child.Label
            _P("mouseoverComponent ", mouseoverComponent)
            PopulateTree(child, mouseoverComponent)
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
    populateChildrenOnClick(tree)
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


