local function getMouseover()
    mouseover = Ext.IMGUI.GetPickingHelper(1)
    if mouseover ~= nil then
        return mouseover
    else
        _P("No mouseover")
    end 
end
local function getEntity()
    entity = Ext.IMGUI.GetPickingHelper(1).Inner.Inner.Character
    if entity ~= nil then
        return entity
    else
        _P("Not a character")
    end
end
local function getItem()
    item = Ext.IMGUI.GetPickingHelper(1).Inner.Inner.Item
    if item ~= nil then
        return item
    else
    _P("Not an Item")
    end
end

Ext.Events.KeyInput:Subscribe(function (e)
    if e.Event == "KeyDown" and e.Repeat == false then
        _P("Something pressed")

        if e.Key == "NUM_1" then
            _P("Num_1 pressed")
            _D(Ext.IMGUI.GetPickingHelper(1))
            dumpMouseover.Label = Ext.DumpExport(getMouseover())

            if getEntity() ~= nil then
                dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(getEntity()):GetAllComponents())
            end

            if getItem() ~= nil then
                dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(getItem()):GetAllComponents())
            end
        end    

        if e.Key == "NUM_2" then
        _P("Num_2 pressed")
        Ext.IO.SaveFile("mouseoverDump.json", Ext.DumpExport(Ext.IMGUI.GetPickingHelper(1)))
        end
    end
end)