function GetMouseover()
    mouseover = Ext.IMGUI.GetPickingHelper(1)
    if mouseover ~= nil then
        return mouseover
    else
        _P("No mouseover")
    end 
end

function GetMouseoverDump()
    return Ext.DumpExport(GetMouseover())
end

function GetEntityUUID()
    entity = Ext.IMGUI.GetPickingHelper(1).Inner.Inner[1].Character
    if entity ~= null then
        return Ext.Entity.HandleToUuid(entity)
    else
        _P("Not a character")
        return null
    end
end

function GetItemUUID()
    item = Ext.IMGUI.GetPickingHelper(1).Inner.Inner[1].Item
    if item ~= null then
        return Ext.Entity.HandleToUuid(item)
    else
        _P("Not an Item")
        return null
    end
end