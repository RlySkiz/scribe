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


