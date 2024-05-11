Node = {}
Node.__index = Node

---@param name string
---@param parent node
---@param children list
function Node:new(name, parent, children)
    local instance = setmetatable({
        name = name,
        parent = parent,
        children = children,
    }, Node)
    return instance
end

-- Returns the Nodes Name
---@return name string
function Node:getName()
    return self.name
end

-- Returns the Nodes Parent
---@return parent node
function Node:getParent()
    return self.parent
end

-- Returns the Nodes Children
---@return children list
function Node:getChildren()
    --if self.children then
        return self.children
    --end
end

-- -- Returns the Nodes Children
-- ---@return children list
-- function Node:getChildrenNames()
--     names = {}
--     if self.children ~nil then
--         for i=1, ipairs(self.children) do    
                    
--             name = self.children[i].name
--             table.insert(names, name)

--             local subchildren = {}
--             if self.children[i]:getChildren() ~nil then
--                 for i=1, ipairs(self.children[i]:getChildren()) do
--                     subchildren = self.children[i]:getChildren()
--                     table.insert(subchildren, name)

--                     if subchildren:getChildren() ~nil then
--                         subchildren:getChildren()
--                     end
--                 end
--                 table.insert(names[i], subchildren)
--             end

    
--         end

--     end
--         return names

-- end



-- Returns the Nodes Children
---@return children list
function Node:getChildrenNames(node, listOfNames)
    if node.children ~= nil then
        for _, child in pairs(node.children) do  
            _P(child.name)
            local sublist = {}
            local entry = {child.name, sublist}
            table.insert(listOfNames, entry)

            -- get children of children
            Node:getChildrenNames(child, sublist)
        end
    end
    
    return listOfNames
end

---@param newChild node
function Node:addChild(newChild)
    table.insert(self.children, newChild)
   -- children[i].Node.name = newChild
end

-- dumpResult = {}
-- function dumpAllChildrenByName()
--     root = self
--     while root.getChildren() ~nil do
--         root.getChildren()
--     end
    
--     _D()
-- end


