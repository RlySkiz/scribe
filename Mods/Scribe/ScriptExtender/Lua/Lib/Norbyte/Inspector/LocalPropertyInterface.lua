local H = Ext.Require("Lib/Norbyte/Helpers.lua")
local IsNodeTypeProperty = H.IsNodeTypeProperty
local CanExpandValue = H.CanExpandValue

--- @class LocalPropertyInterface
local LocalPropertyInterface = {}

function LocalPropertyInterface:FetchSetChildren(obj, handler, typeInfo)
    local props = {}
    local nodes = {}

    for key=1,#obj do
        local val = Ext.Types.GetHashSetValueAt(obj, key)
        if IsNodeTypeProperty(val) then
            table.insert(nodes, {Key=key, CanExpand=CanExpandValue(val)})
        else
            table.insert(props, {Key=key, Value=val})
        end
    end

    handler(nodes, props, typeInfo)
end

function LocalPropertyInterface:FetchChildrenInternal(obj, handler, typeInfo)
    local props = {}
    local nodes = {}

    local keys = {}
    for key,val in pairs(obj) do
        table.insert(keys, key)
    end

    table.sort(keys)
    for _,key in ipairs(keys) do
        local val = obj[key]
        if IsNodeTypeProperty(val) then
            table.insert(nodes, {Key=key, CanExpand=CanExpandValue(val)})
        else
            table.insert(props, {Key=key, Value=val})
        end
    end

    handler(nodes, props, typeInfo)
end

---@param path ObjectPath
function LocalPropertyInterface:FetchChildren(path, handler)
    local obj = path:Resolve()
    if obj ~= nil then
        local typeName = Ext.Types.GetObjectType(obj)
        local typeInfo = Ext.Types.GetTypeInfo(typeName)

        local attrs
        if typeName == "Entity" then
            attrs = obj:GetAllComponents(false)
        else
            attrs = obj
        end

        if typeInfo ~= nil and typeInfo.Kind == "Set" then
            return self:FetchSetChildren(attrs, handler, typeInfo)
        else
            return self:FetchChildrenInternal(attrs, handler, typeInfo)
        end
    end

    handler({}, {}, nil)
end

---@param path ObjectPath
---@param key string
---@param value any
function LocalPropertyInterface:SetProperty(path, key, value)
    local obj = path:Resolve()
    if obj ~= nil then
        obj[key] = value
    end
end

return LocalPropertyInterface
