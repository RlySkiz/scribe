local function getMouseover()
    mouseover = Ext.IMGUI.GetPickingHelper(1)
    if mouseover ~= nil then
        return mouseover
    else
        _P("No mouseover")
    end 
end
local function getEntityUUID()
    entity = Ext.IMGUI.GetPickingHelper(1).Inner.Inner[1].Character
    if entity ~= nil then
        return Ext.Entity.HandleToUuid(entity)
    else
        _P("Not a character")
    end
end
local function getItemUUID()
    item = Ext.IMGUI.GetPickingHelper(1).Inner.Inner[1].Item
    if item ~= nil then
        return Ext.Entity.HandleToUuid(item)
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

            if getEntityUUID() ~= nil then
                -- Ext.DumpExport(Ext.Entity.Get(getEntityUUID())
                entityName.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()).CustomName.Name)
                entityRace.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()).Race.Race)
                entityBodyType.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()).BodyType.BodyType)
                
                if GetPropertyOrDefault(Ext.Entity.Get(getEntityUUID()), "ServerCharacter", nil) then
                    entityCVID.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()).ServerCharacter.Template.CharacterVisualResourceID)
                    dumpVisual.Label = Ext.DumpExport(Ext.Resource.Get(entityCVID.Label, "Visual"))
                end

                dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()):GetAllComponents())
            end

            if getItemUUID() ~= nil then
                dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(getItemUUID()):GetAllComponents())
            end
        end    

        if e.Key == "NUM_2" then
        _P("Num_2 pressed")
        Ext.IO.SaveFile("mouseoverDump.json", Ext.DumpExport(Ext.IMGUI.GetPickingHelper(1)))
        end
    end
end)