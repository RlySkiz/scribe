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
                
                -- Get ServerCharacter Dump
                Ext.Net.PostMessageToServer("RequestServerCharacter", getEntityUUID())


                --if GetPropertyOrDefault(Ext.Entity.Get(getEntityUUID()), "ServerCharacter", nil) then
                --    _P("ServerCharacter Found!")
                --    entityCVID.Label = Ext.Entity.Get(getEntityUUID()).ServerCharacter.Template.CharacterVisualResourceID
                --    _P("Added EntityVisual")
                --    dumpVisual.Label = Ext.DumpExport(Ext.Resource.Get(entityCVID.Label, "Visual"))
                --else
                --    _P("Not a ServerCharacter")
                --end

                dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()):GetAllComponents())
            end

            if getItemUUID() ~= nil then
                dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(getItemUUID()):GetAllComponents())
            end
        end    

        if e.Key == "NUM_2" then
        _P("Num_2 pressed")
        Ext.IO.SaveFile("mouseoverDump.json", Ext.DumpExport(getMouseover())
        Ext.IO.SaveFile("entityDump.json"), Ext.DumpExport(getEntityUUID())
        end
    end
end)

Ext.Events.NetMessage:Subscribe(function(e) 
    if (e.Channel == "SendServerCharacterDump") then
        local dump = Ext.Json.Parse(e.Payload)
        entityCVID.Label = dump
        dumpVisual.Label = Ext.Resource.Get(entityCVID.Label, "Visual")
    end
end)