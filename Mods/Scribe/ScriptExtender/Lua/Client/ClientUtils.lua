function getMouseover()
    mouseover = Ext.IMGUI.GetPickingHelper(1)
    if mouseover ~= nil then
        return mouseover
    else
        _P("No mouseover")
    end 
end
function getEntityUUID()
    entity = Ext.IMGUI.GetPickingHelper(1).Inner.Inner[1].Character
    if entity ~= nil then
        return Ext.Entity.HandleToUuid(entity)
    else
        _P("Not a character")
    end
end
function getItemUUID()
    item = Ext.IMGUI.GetPickingHelper(1).Inner.Inner[1].Item
    if item ~= nil then
        return Ext.Entity.HandleToUuid(item)
    else
    _P("Not an Item")
    end
end