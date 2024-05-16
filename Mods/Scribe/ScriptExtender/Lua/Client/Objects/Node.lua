Node = {}
Node.__index = Node



--------------------------------------------------------------------------------
--                                      Constructor
--------------------------------------------------------------------------------

---@param name string
---@param parent node
---@param children list
---@param ID string
---@param bullet boolean
function Node:new(name, parent, children, ID, bullet)
    local instance = setmetatable({
        name = name,
        parent = parent,
        children = children,
        ID = ID,
        bullet = bullet,
    }, Node)
    return instance
end


--------------------------------------------------------------------------------
--                               Getters and setters
--------------------------------------------------------------------------------


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
    return self.children
end

-- Returns the Nodes ID
function Node:getID()
    return self.ID
end


-- Returns whether the Node has the Bullet Property
function Node:getBullet()
    return self.Bullet
end


-- Adds a new child to the nodes list of children
---@param newChild node
function Node:addChild(newChild)
    table.insert(self.children, newChild)
end
