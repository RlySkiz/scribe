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



--------------------------------------------------------------------------------
--                               Methods
--------------------------------------------------------------------------------


local ID = 1

-- converts a table to a tree using the custom Node class - calls tableToNodeRecurse
--@param rootName str - optional name for the parent, else root is chosen
--@param tbl table    - original table to be converted
--@return tree Node   - the Node with all of the information in the table
function TableToNode(rootName, tbl)

    local parentName = "root"
    if rootName then
        parentName = rootName
    end

    local parent = Node:new(rootName, {}, 1, 0)
    tableToNodeRecurse(tbl, parent, 1)

    -- reset ID for next function call
    ID = 1

    -- parent appended with children
    return parent
end



-- converts a table to a tree using the custom Node class, called by tableToNode internally
--@param tbl table    - original table to be converted
--@param parent Node  - parent Node
--@return tree Node   - the Node with all of the information in the table
local function tableToNodeRecurse(tbl, parent)
    ID =  ID + 1
    success, iterator = pcall(pairs, tbl)
    if success == true and (type(tbl) == "table" or type(tbl) == "userdata") then
        for label,content in pairs(tbl) 
            if content then
                -- special case for empty table
                local stringify = Ext.Json.Stringify(content, STRINGIFY_OPTIONS)
                if stringify == "{}" then
                    parent.addChild(Node:new("{}", parent, {},ID , 1))    
                else
                    local child = parent.addChild(Node:new(tostring(label), parent, {},ID , 0))    
                    tableToNodeRecurse(label, content, child, ID)   
                end
            else
                parent.addChild(Node:new(tostring(label), parent, {},ID , 1))    
            end
        end
    else
        parent.addChild(Node:new(tostring(tableToNode), parent, {},ID , 1))    
    end
end