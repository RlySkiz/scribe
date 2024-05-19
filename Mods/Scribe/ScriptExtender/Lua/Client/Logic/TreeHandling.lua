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

local ID = 0
-- Populate a tree
--@param tree userdata/Tree      - tree that the children will be added to
--@param currentTable table      - table with the label, content pairs
function PopulateTree(tree, currentTable)
    tree.IDContext = tree.Label .. tostring(ID)
    _P("Generated new Tree with ID: ", tree.IDContext) -- DEBUG
    ID = 0

    success, iterator = pcall(pairs, currentTable)
    if success == true and (type(currentTable) == "table" or type(currentTable) == "userdata") then
        for label,content in pairs(currentTable) do
            if content then
                -- special case for empty table
                local stringify = Ext.Json.Stringify(content, STRINGIFY_OPTIONS)
                if stringify == "{}" then
                    local newTree = tree:AddTree(tostring(label))
                    ID = ID+1
                    newTree.IDContext = tree.Label .. tostring(ID)
                    newTree.Label = newTree.Label .. " | " .. "P: " .. tree.Label .. " | " .. "ID: " .. newTree.IDContext -- DEBUG
                    newTree.Bullet = true
                    _P("Generated new Tree with ID: ", newTree.IDContext) -- DEBUG
                    -- _D(tree.Children)
                else
                    local newTree = tree:AddTree(tostring(label))
                    ID = ID+1
                    newTree.IDContext = tree.Label .. tostring(ID)
                    newTree.Label = newTree.Label .. " | " .. "P: " .. tree.Label .. " | " .. "ID: " .. newTree.IDContext -- DEBUG
                    _P("Generated new Tree with ID: ", newTree.IDContext) -- DEBUG
                    -- _D(tree.Children)
                end
            else
                local newTree = tree:AddTree(tostring(label))
                ID = ID+1
                newTree.IDContext = tree.Label .. tostring(ID)
                newTree.Label = newTree.Label .. " | " .. "P: " .. tree.Label .. " | " .. "ID: " .. newTree.IDContext -- DEBUG
                newTree.Bullet = true
                _P("Generated new Tree with ID: ", newTree.IDContext) -- DEBUG
                -- _D(tree.Children)
            end

        end
    else
        local newTree = tree:AddTree(tostring(currentTable))
        ID = ID+1
        newTree.IDContext = tree.Label .. tostring(ID)
        newTree.Label = newTree.Label .. " | " .. "P: " .. tree.Label .. " | " .. "ID: " .. newTree.IDContext -- DEBUG
        newTree.Bullet = true
        _P("Generated new Tree with ID: ", newTree.IDContext) -- DEBUG
        -- _D(tree.Children)
    end
    ID = 0
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


