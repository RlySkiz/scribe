local H = Ext.Require("Lib/Norbyte/Helpers.lua")
local GetPropertyMeta = H.GetPropertyMeta

local PropertyEditorFactory = require("Lib.Norbyte.Inspector.PropertyEditor")

--- @class PropertyListView
--- @field PropertyInterface LocalPropertyInterface
--- @field Parent ExtuiTreeParent
--- @field Target ObjectPath
--- @field OnEntityClick fun(path:ObjectPath)
PropertyListView = {
}

---@return PropertyListView
---@param intf LocalPropertyInterface|NetworkPropertyInterface
---@param parent ExtuiTreeParent
function PropertyListView:New(intf, parent)
	local o = {
        Target = nil,
        Parent = parent,
        PropertyInterface = intf,
        OnEntityClick = nil
	}
	setmetatable(o, self)
    self.__index = self
    o:Init()
    return o
end


function PropertyListView:Init()
    self.PropertiesPane = self.Parent:AddTable("Properties", 2)
    self.PropertiesPane.PositionOffset = {5, 2}
    self.PropertiesPane:AddColumn("Name")
    self.PropertiesPane:AddColumn("Value")
end


---@param path ObjectPath
---@param holder ExtuiTreeParent
---@param key any
---@param value any
---@param propInfo TypeInformationRef|nil
function PropertyListView:AddPropertyEditor(path, holder, key, value, propInfo)
    if propInfo ~= nil then
        local setter = function (value, vKey, vPath)
            self.PropertyInterface:SetProperty(vPath or path, vKey or key, value)
        end
        PropertyEditorFactory:CreateEditor(holder, path, key, value, propInfo, setter)
    else
        holder:AddText(tostring(value))
    end
end


function PropertyListView:AddProperty(path, typeInfo, key, value)
    if type(value) == "function" then return end

    local prop = self.PropertiesPane:AddRow()
    prop.IDContext = tostring(key)
    prop:AddCell():AddText(tostring(key))
    local holder = prop:AddCell()
    local propInfo = GetPropertyMeta(typeInfo, key)
    self:AddPropertyEditor(path, holder, key, value, propInfo)
end


---@param target ObjectPath
function PropertyListView:SetTarget(target)
    self.Target = target
end


function PropertyListView:Refresh()
    while #self.PropertiesPane.Children > 0 do
        self.PropertiesPane:RemoveChild(self.PropertiesPane.Children[#self.PropertiesPane.Children])
    end

    if not self.Target then return end

    self.PropertyInterface:FetchChildren(self.Target, function (nodes, properties, typeInfo)
        for _,info in ipairs(properties) do
            self:AddProperty(self.Target, typeInfo, info.Key, info.Value)
        end
    end)
end

return PropertyListView
